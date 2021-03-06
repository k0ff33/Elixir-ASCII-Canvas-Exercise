defmodule CanvasServerWeb.DrawingLive.Index do
  use CanvasServerWeb, :live_view

  alias CanvasServer.Art
  alias CanvasServer.Art.Drawing

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Art.subscribe()
    {:ok, assign(socket, :drawings, list_drawings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Drawing")
    |> assign(:drawing, %Drawing{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Drawings")
    |> assign(:drawing, nil)
  end

  @impl true
  def handle_info({:drawing_created, drawing}, socket) do
    {:noreply, update(socket, :drawings, fn drawings -> [drawing | drawings] end)}
  end

  defp list_drawings do
    Art.list_drawings()
  end
end
