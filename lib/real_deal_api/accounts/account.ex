defmodule RealDealApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :hashed_password, :string
    has_one :user, RealDealApi.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :hashed_password])
    |> validate_required([:email, :hashed_password])
    |> validate_format(:email, ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/, message: "must be a valid email address")
    |> validate_length(:email, max: 255, message: "must be at most 255 characters")
    |> unique_constraint(:email)
  end
end