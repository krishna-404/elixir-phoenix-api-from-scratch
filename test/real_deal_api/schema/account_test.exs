defmodule RealDealApi.Schema.AccountTest do
  use RealDealApi.Support.DataCase
  use RealDealApi.Support.SchemaCase
  alias RealDealApi.Accounts.Account
  alias Ecto.Changeset

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(RealDealApi.Repo)
  end

  @expected_fields_with_types [
    {:id, :binary_id},
    {:email, :string},
    {:hashed_password, :string},
    {:inserted_at, :utc_datetime},
    {:updated_at, :utc_datetime}
  ]

  describe "fields and types" do
    test "all fields are present and have the correct types" do
      # assert Account.__schema__(:fields) == @expected_fields_with_types
      actual_fields_with_types = for field <- Account.__schema__(:fields) do
        type = Account.__schema__(:type, field)
        {field, type}
      end

      assert MapSet.new(actual_fields_with_types) == MapSet.new(@expected_fields_with_types)
    end
  end

  describe "changeset/2" do
    test "success: returns a valid changeset when given valid attributes" do
      valid_values = valid_params([{:email, :string}, {:hashed_password, :string}])

      changeset = Account.changeset(%Account{}, valid_values)
      assert %Ecto.Changeset{valid?: true, changes: changes} = changeset

      mutated = [:hashed_password]
      for {field, _} <- @expected_fields_with_types, field not in mutated do
        actual = Map.get(changes, field)
        expected = valid_values[Atom.to_string(field)]
        assert actual == expected, "Values for #{field} do not match\nActual: #{inspect(actual)}\nExpected: #{inspect(expected)}"
      end

      assert Bcrypt.verify_pass(valid_values["hashed_password"], changes.hashed_password), "Password: #{inspect(valid_values["hashed_password"])} does not match\n hash: #{inspect(changes.hashed_password)}"
    end
  end

  describe "error: returns an error changeset when given invalid attributes" do
    test "email is required" do
      changeset = Account.changeset(%Account{}, %{})
      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).email
      assert "can't be blank" in errors_on(changeset).hashed_password
    end

    test "error: email is not a valid email" do
      changeset = Account.changeset(%Account{}, %{"email" => "invalid-email", "hashed_password" => "password"})
      refute changeset.valid?
      assert "must be a valid email address" in errors_on(changeset).email
    end

    test "error: email address is reused" do
      # This allows to start database in an empty state.
      # Ecto.Adapters.SQL.Sandbox.checkout(RealDealApi.Repo)

      {:ok, _} =
        %Account{}
        |> Account.changeset(%{email: "test@test.com", hashed_password: "password"})
        |> RealDealApi.Repo.insert()

      changeset = Account.changeset(%Account{}, %{"email" => "test@test.com", "hashed_password" => "password"})

      assert {:error, %Changeset{valid?: false, errors: errors}} = RealDealApi.Repo.insert(changeset)

      assert errors[:email], "The field email is missing from errors."

      {_, meta} = errors[:email]

      assert meta[:constraint] == :unique, "The validation type, #{meta[:validation]}, is incorrect"
    end
  end
end
