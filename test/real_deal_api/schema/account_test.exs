defmodule RealDealApi.Schema.AccountTest do
  use ExUnit.Case
  alias RealDealApi.Accounts.Account

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
end
