defmodule Crypto.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crypto.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "currencies" do
    field :current_price, :decimal
    field :name, :string
    field :priced_at, :naive_datetime
    field :likes_count, :integer

    many_to_many :users, User, join_through: "user_currencies"

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name, :current_price, :priced_at])
    |> validate_required([:name, :current_price, :priced_at])
  end
end
