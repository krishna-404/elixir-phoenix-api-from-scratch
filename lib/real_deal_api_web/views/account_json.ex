defmodule RealDealApiWeb.AccountJSON do
  alias RealDealApi.Accounts.Account

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

  def account_token(%{account: account, token: token}) do
    %{
      id: account.id,
      email: account.email,
      token: token
    }
  end
end
