defmodule Demoo.Repo do
  use Ecto.Repo,
    otp_app: :demoo,
    adapter: Ecto.Adapters.SQLite3
end
