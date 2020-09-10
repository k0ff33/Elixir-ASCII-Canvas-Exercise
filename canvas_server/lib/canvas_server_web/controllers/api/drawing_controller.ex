defmodule CanvasServerWeb.Api.DrawingController do
  use CanvasServerWeb, :controller

  alias CanvasServer.Art

  def index(conn, _params) do
    drawings = Art.list_drawings()
    json(conn, %{data: drawings})
  end

  def show(conn, %{"id" => id}) do
    drawing = Art.get_drawing!(id)
    json(conn, %{data: drawing})
  end

  def create(conn, %{"operations" => drawing_operations}) do
    case Asciicanvas.draw(drawing_operations) do
      {:ok, image} ->
        case Art.create_drawing(%{:drawing => image}) do
          {:ok, _drawing} ->
            json(conn, %{message: "Drawing created successfully"})

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: changeset})
        end

      {:error, message} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: message})
    end
  end
end
