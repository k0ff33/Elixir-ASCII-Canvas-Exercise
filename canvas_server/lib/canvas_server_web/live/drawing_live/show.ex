defmodule CanvasServerWeb.DrawingLive.Show do
  use CanvasServerWeb, :live_view

  alias CanvasServer.Ascii

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:drawing, Ascii.get_drawing!(id))}
  end

  defp page_title(:show), do: "Show Drawing"
  defp page_title(:edit), do: "Edit Drawing"
end