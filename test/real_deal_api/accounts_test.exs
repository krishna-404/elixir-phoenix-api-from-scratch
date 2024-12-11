defmodule RealDealApi.AccountsTest do
  use RealDealApi.Support.DataCase
  alias RealDealApi.{Accounts, Accounts.Account}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(RealDealApi.Repo)
  end

  describe "create_account/1" do
    test "sucess: insert an account in the database  & returns the account" do
      params = Factory.string_params_for(:account)
      assert {:ok, %Account{} = returned_account} = Accounts.create_account(params)

      account_from_db = Repo.get(Account, returned_account.id)
      assert account_from_db == returned_account

      mutated = ["hashed_password"]
      for {param_field, expected} <- params, param_field not in mutated do
        schema_field = String.to_existing_atom(param_field)
        actual = Map.get(returned_account, schema_field)

        assert actual == expected, "Values did not match for #{param_field}\nexpected: #{inspect(expected)}\nactual: #{inspect(actual)}"
      end

      assert Bcrypt.verify_pass(params["hashed_password"], returned_account.hashed_password),
        "Pasword: #{inspect(params["hashed_password"])} does not match hashed_password: #{inspect(returned_account.hashed_password)}"

      assert account_from_db.inserted_at == account_from_db.updated_at
    end

    test "error: returns an error when params are missing" do
      missing_params = %{}
      assert {:error, %Changeset{valid?: false}} = Accounts.create_account(missing_params)
    end
  end
end
