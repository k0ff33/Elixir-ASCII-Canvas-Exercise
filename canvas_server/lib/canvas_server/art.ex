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
    Drawing |> order_by(desc: :inserted_at) |> Repo.all()
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
  def create_drawing(attrs \\ %{}) do
    %Drawing{}
    |> Drawing.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:drawing_created)
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
