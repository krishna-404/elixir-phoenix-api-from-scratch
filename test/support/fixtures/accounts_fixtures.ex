defmodule RealDealApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RealDealApi.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        email: "some_email@example.com",
        hashed_password: "some hashed_password",
        full_name: "some full_name",
        gender: "male",
        biography: "some biography"
      })
      |> RealDealApi.Accounts.create_account()

    account
  end
end
