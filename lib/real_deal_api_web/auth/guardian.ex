defmodule RealDealApiWeb.Auth.Guardian do
  use Guardian, otp_app: :real_deal_api

  alias RealDealApi.Accounts

  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_account!(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def authenticate(email, password) do
    case Accounts.get_account_by_email(email) do
      nil -> {:error, :unauthorised}
      account ->
        case verify_password(password, account.hashed_password) do
          true -> create_token(account, :access)
          false -> {:error, :unauthorised}
        end
    end
  end

  def authenticate(token) do
    with {:ok, claims} <- decode_and_verify(token),
      {:ok, account} <- resource_from_claims(claims),
      {:ok, _old, {new_token, _new_claims}} <- refresh(token) do
        {:ok, account, new_token}
      end
  end

  defp verify_password(password, hashed_password) do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def get_token(conn) do
    Guardian.Plug.current_token(conn)
  end

  defp create_token(account, type) do
    {:ok, token, _claims} = encode_and_sign(account, %{}, token_options(type))
    {:ok, account, token}
  end

  defp token_options(type) do
    case type do
      :access -> [token_type: "access", ttl: {1, :hour}]
      :reset -> [token_type: "reset", ttl: {1, :minute}]
      :admin -> [token_type: "admin", ttl: {90, :day}]
    end
  end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end
