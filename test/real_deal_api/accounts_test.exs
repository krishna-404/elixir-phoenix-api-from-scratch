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

  describe "get_account/1" do
    test "success: returns an account with valid id" do
      # When using Factory.insert, the account is inserted into the database without going through the create_account function
      # & hence it bypasses the changeset validation
      # Which also means that the hashed_password is not set & the password is set as plain text
      existing_account = Factory.insert(:account)
      assert returned_account = Accounts.get_account!(existing_account.id)
      assert returned_account == existing_account
    end

    test "error: raises an Ecto.NoResultsError when an account doesn't exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_account!(Ecto.UUID.generate())
      end
    end
  end

  describe "get_account_by_email/1" do
    test "success: returns an account with valid email" do
      existing_account = Factory.insert(:account)
      assert returned_account = Accounts.get_account_by_email(existing_account.email)
      assert returned_account == existing_account
    end

    test "error: returns nil when an account doesn't exist" do
      assert nil == Accounts.get_account_by_email("nonexistent@example.com")
    end
  end

  describe "update_account/2" do
    test "success: updates an account" do
      existing_account = Factory.insert(:account)
      params = Factory.string_params_for(:account) |> Map.take(["email"])
      assert {:ok, %Account{} = returned_account} = Accounts.update_account(existing_account, params)
      assert returned_account.email == params["email"]

      account_from_db = Repo.get(Account, existing_account.id)
      assert account_from_db.email == params["email"]
      assert returned_account == account_from_db

      expected_account_data = existing_account |> Map.from_struct() |> Map.put(:email, params["email"])
      for {field, expected} <- expected_account_data do
        assert Map.get(account_from_db, field) == expected, "Values did not match for #{field}\nexpected: #{inspect(expected)}\nactual: #{inspect(Map.get(account_from_db, field))}"
      end
    end

    test "error: returns an error when params are invalid" do
      existing_account = Factory.insert(:account)
      assert {:error, %Changeset{valid?: false}} = Accounts.update_account(existing_account, %{email: "invalid_email"})

      account_from_db = Repo.get(Account, existing_account.id)
      assert account_from_db.email == existing_account.email
    end
  end

  describe "delete_account/1" do
    test "success: deletes an account" do
      existing_account = Factory.insert(:account)
      assert {:ok, %Account{}} = Accounts.delete_account(existing_account)
      refute Repo.get(Account, existing_account.id)
    end
  end
end
