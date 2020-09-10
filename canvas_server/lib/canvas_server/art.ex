defmodule CanvasServer.Art do
  @moduledoc """
  The Art context.
  """

  import Ecto.Query, warn: false
  alias CanvasServer.Repo

  alias CanvasServer.Art.Drawing

  @doc """
  Returns the list of drawings.

  ## Examples

      iex> list_drawings()
      [%Drawing{}, ...]

  """
  def list_drawings do
    Repo.all(Drawing)
  end

  @doc """
  Gets a single drawing.

  Raises `Ecto.NoResultsError` if the Drawing does not exist.

  ## Examples

      iex> get_drawing!(123)
      %Drawing{}

      iex> get_drawing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_drawing!(id), do: Repo.get!(Drawing, id)

  @doc """
  Creates a drawing.

  ## Examples

      iex> create_drawing(%{field: value})
      {:ok, %Drawing{}}

      iex> create_drawing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_drawing(%{:drawing => drawing_operations}) do
    Asciicanvas.draw(drawing_operations)
    |> (fn image -> %Drawing{:drawing => image} end).()
    |> Repo.insert()
    |> broadcast(:drawing_created)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking drawing changes.

  ## Examples

      iex> change_drawing(drawing)
      %Ecto.Changeset{data: %Drawing{}}

  """
  def change_drawing(%Drawing{} = drawing, attrs \\ %{}) do
    Drawing.changeset(drawing, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(CanvasServer.PubSub, "drawings")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, drawing}, event) do
    Phoenix.PubSub.broadcast(CanvasServer.PubSub, "drawings", {event, drawing})
    {:ok, drawing}
  end
end
