defmodule Crypto.UserCurrencies do
  import Ecto.Query, warn: false
  alias Crypto.Repo

  alias Crypto.Accounts.User
  alias Crypto.Currencies.Currency
  alias Crypto.UserCurrencies.UserCurrency

  def list_user_currencies do
    Repo.all(UserCurrency)
  end

  # def favorite_currency(%User{} = user, %Currency{} = currency) do
  #   %UserCurrency{user: user, currency: currency}
  #   |> Repo.insert!()
  #   |> broadcast(:user_currency_updated)
  # end

  def favorite_currency(%User{} = user, %Currency{} = currency) do
    user
    |> Repo.preload(:currencies)
    |> User.changeset_update_currencies([currency])
    |> Repo.update!()
    |> broadcast(:user_currency_updated)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Crypto.PubSub, "user_currencies")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, user_currency}, event) do
    Phoenix.PubSub.broadcast(Crypto.PubSub, "user_currencies", {event, user_currency})
    {:ok, user_currency}
  end
end
