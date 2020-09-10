defmodule CanvasServerWeb.Api.DrawingController do
  use CanvasServerWeb, :controller

  alias CanvasServer.Art

  def index(conn, _params) do
    drawings = Art.list_drawings()
    json(conn, %{data: drawings})
  end

  def show(conn, %{"id" => id}) do
    drawing = Art.get_drawing!(id)
    json(conn, drawing)
  end
end
