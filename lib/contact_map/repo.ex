defmodule ContactMap.Repo do
  use Ecto.Repo,
    otp_app: :contact_map,
    adapter: Ecto.Adapters.Postgres
end
