defmodule CanvasServer.Repo do
  use Ecto.Repo,
    otp_app: :canvas_server,
    adapter: Ecto.Adapters.Postgres
end
