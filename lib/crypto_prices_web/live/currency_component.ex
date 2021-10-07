defmodule CryptoWeb.PageLive.CurrencyComponent do
  use CryptoWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="flex flex-grow justify-between p-6 bg-white hover:bg-gray-100 shadow-md border border-gray-200 rounded-lg max-w-sm">
        <div>
            <h3 class="text-gray-900 font-bold text-2xl tracking-tight m-0"><%= @currency.name %></h3>
            <p class="font-normal text-gray-700 m-0"><%= @currency.current_price %></p>
        </div>
        <div class="cursor-pointer">
          <span class="flex" phx-click="favorite" phx-target="<%= @myself %>">
            <p class="text-center m-0"><%= @currency.likes_count %></p>
            <svg width="20" class="m-0 text-pink-600" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
            </svg>
          </span>
        </div>
        <%= #if Enum.any?(@user.currencies, fn c -> c.name == @currency.name end) do "text-pink-600" else "text-black" end %>
    </div>
    """
  end

  def handle_event("favorite", _, socket) do
    Crypto.UserCurrencies.favorite_currency(socket.assigns.user, socket.assigns.currency)
    {:noreply, socket}
  end
end
