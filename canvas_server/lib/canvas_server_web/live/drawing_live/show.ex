defmodule CanvasServerWeb.DrawingLive.Show do
  use CanvasServerWeb, :live_view

  alias CanvasServer.Art

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply, socket |> assign(:drawing, Art.get_drawing!(id))}
  end
end
