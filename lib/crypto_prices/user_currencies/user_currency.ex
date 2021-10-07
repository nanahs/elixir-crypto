defmodule Crypto.UserCurrencies.UserCurrency do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crypto.Accounts.User
  alias Crypto.Currencies.Currency

  @already_exists "ALREADY_EXISTS"
  @primary_key false

  schema "user_currencies" do
    belongs_to(:user, User, primary_key: true)
    belongs_to(:currency, Currency, primary_key: true)
  end

  @required_fields ~w(user_id project_id)a
  def changeset(user_currency, attrs \\ %{}) do
    user_currency
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:project_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:user, :currency],
      name: :user_id_currency_id_unique_index,
      message: @already_exists
    )
  end
end
