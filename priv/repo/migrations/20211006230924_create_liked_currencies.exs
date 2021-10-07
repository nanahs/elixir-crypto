defmodule Crypto.Repo.Migrations.CreateUserCurrencies do
  use Ecto.Migration

  def change do
    create table(:user_currencies, primary_key: false) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :currency_id, references(:currencies, type: :binary_id, on_delete: :delete_all), null: false
    end
  end
end
