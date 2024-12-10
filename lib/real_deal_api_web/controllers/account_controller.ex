defmodule RealDealApiWeb.AccountController do
  use RealDealApiWeb, :controller

  alias RealDealApi.{Accounts, Accounts.Account, Users, Users.User}
  alias RealDealApiWeb.Auth.{ErrorResponse.Unauthorised, Guardian}

  import RealDealApiWeb.Auth.AuthorizedPlug
  plug :is_authorised when action in [:show, :update, :delete]

  action_fallback RealDealApiWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
      {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      authorise_account(conn, account.email, account_params["hashed_password"])
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    authorise_account(conn, email, password)
  end

  defp authorise_account(conn, email, password) do
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

  def current_account(conn, %{}) do
    conn
    |> put_status(:ok)
    |> render(:show, account: conn.assigns.account)
  end

  def update(conn, %{"current_password" => current_password, "account" => account_params}) do
    case Guardian.verify_password(current_password, conn.assigns.account.hashed_password) do
      true ->
        {:ok, account} = Accounts.update_account(conn.assigns.account, account_params)
        render(conn, :show, account: account)
      false -> raise Unauthorised, message: "Invalid current password"
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end

  def refresh_session(conn, _opts) do
    current_token = Guardian.get_token(conn)
    {:ok, account, new_token} = Guardian.authenticate(current_token)
    conn |> Plug.Conn.put_session(:account_id, account.id) |> put_status(:ok) |> render(:account_token, %{account: account, token: new_token})
  end

  def sign_out(conn, %{}) do
    account = conn.assigns[:account]
    token = Guardian.get_token(conn)
    Guardian.revoke(token)
    conn |> Plug.Conn.clear_session() |> put_status(:ok) |> render(:account_token, %{account: account, token: nil})
  end
end
