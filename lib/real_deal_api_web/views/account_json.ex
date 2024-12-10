defmodule RealDealApiWeb.AccountJSON do
  alias RealDealApi.Accounts.Account
  alias RealDealApiWeb.UserJSON

  def index(%{accounts: accounts}) do
    accounts |> Enum.map(&data/1)
  end

  def show(%{account: account}) do
    data(account)
  end

  def data(%Account{} = account) do
    %{
      id: account.id,
      email: account.email,
      inserted_at: account.inserted_at,
      updated_at: account.updated_at
    }
  end

  def full_account(%{account: account}) do
    %{
      id: account.id,
      email: account.email,
      inserted_at: account.inserted_at,
      updated_at: account.updated_at,
      user: UserJSON.show(%{user: account.user})
    }
  end

  def account_token(%{account: account, token: token}) do
    %{
      id: account.id,
      email: account.email,
      token: token
    }
  end
end
