defmodule CryptoWeb.PageLive do
  require Record
  use CryptoWeb, :live_view

  import Ecto.Query

  alias Crypto.Currencies
  alias Crypto.UserCurrencies

  @impl true
  def mount(_params, session, socket) do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)

    repo_currencies = Currencies.list_currencies()

    endpoints = [
      'http://api.coinbase.com/v2/prices/BTC-USD/buy',
      'http://api.coinbase.com/v2/prices/ETH-USD/buy',
      'http://api.coinbase.com/v2/prices/DOGE-USD/buy'
    ]

    Enum.map(endpoints, fn e ->
      {:ok, {_thing, _headers, body}} = :httpc.request(:get, {e, []}, [], [])

      data = Jason.decode!(body)["data"]

      %{
        priced_at: DateTime.to_naive(DateTime.utc_now()),
        name: data["base"],
        current_price: data["amount"]
      }
    end)
    |> Enum.map(fn c ->
      okm =
        Enum.find(repo_currencies, nil, fn rc ->
          IO.inspect(rc)
          rc.name == c.name
        end)

      case okm do
        nil ->
          Currencies.create_currency(c)

        e ->
          Currencies.update_currency(e, c)
      end
    end)

    user =
      case session["user_token"] do
        nil ->
          nil

        token ->
          Crypto.Accounts.get_user_by_session_token(token)
      end

    if connected?(socket), do: UserCurrencies.subscribe()

    {:ok,
     assign(
       socket,
       %{
         currencies: Currencies.list_currencies(),
         user: user
       }
     )}
  end

  @impl true
  def handle_info({:user_currency_updated, user_currency}, socket) do
    IO.puts("USER CURRENCY UPDATED EVENT")
  end
end
