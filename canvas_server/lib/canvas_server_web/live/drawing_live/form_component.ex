defmodule CanvasServerWeb.DrawingLive.FormComponent do
  use CanvasServerWeb, :live_component

  alias CanvasServer.Art

  @impl true
  def update(%{drawing: drawing} = assigns, socket) do
    changeset = Art.change_drawing(drawing)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"drawing" => drawing_params}, socket) do
    changeset =
      socket.assigns.drawing
      |> Art.change_drawing(drawing_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"drawing" => drawing_params}, socket) do
    save_drawing(socket, socket.assigns.action, drawing_params)
  end

  defp save_drawing(socket, :new, %{"drawing" => drawing_params}) do
    operations = String.split(drawing_params, "\n", trim: true)

    case Art.create_drawing(%{:drawing => operations}) do
      {:ok, _drawing} ->
        {:noreply,
         socket
         |> put_flash(:info, "Drawing created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
