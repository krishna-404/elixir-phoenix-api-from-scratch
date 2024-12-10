defmodule RealDealApiWeb.AccountController do
  use RealDealApiWeb, :controller

  alias RealDealApi.{Accounts, Accounts.Account, Users, Users.User}
  alias RealDealApiWeb.Auth.{ErrorResponse.Forbidden, ErrorResponse.Notfound, ErrorResponse.Unauthorised, Guardian}

  plug :is_authorised_account when action in [:show, :update, :delete]

  action_fallback RealDealApiWeb.FallbackController

  defp is_authorised_account(conn, _opts) do
    %{params: %{"account" => params}} = conn
    account = Accounts.get_account!(params["id"])
    if conn.assigns[:account].id == account.id, do: conn, else: raise Forbidden
  end

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
      {:ok, token, _claims} <- Guardian.encode_and_sign(account),
      {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      conn
      |> put_status(:created)
      |> render(:account_token, account: account, token: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render(:account_token, %{account: account, token: token})

      {:error, :unauthorised} -> raise Unauthorised, message: "Invalid email or password"
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  def update(conn, %{"account" => account_params}) do
    account = Accounts.get_account!(account_params["id"])

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end

  def refresh_session(conn, _opts) do
    old_token = Guardian.get_token(conn)
    case Guardian.decode_and_verify(old_token) do
      {:ok, claims} ->
        case Guardian.resource_from_claims(claims) do
          {:ok, account} ->
            {:ok, {_old_token, _old_claims}, {new_token, _new_claims}} = Guardian.refresh(old_token, [])
            conn |> Plug.Conn.put_session(:account_id, account.id) |> put_status(:ok) |> render(:account_token, %{account: account, token: new_token})
          {:error, _reason} ->
            raise Notfound
        end
      {:error, _reason} ->
        raise Notfound
    end
  end

  def sign_out(conn, %{}) do
    account = conn.assigns[:account]
    token = Guardian.get_token(conn)
    Guardian.revoke(token)
    conn |> Plug.Conn.clear_session() |> put_status(:ok) |> render(:account_token, %{account: account, token: nil})
  end
end
