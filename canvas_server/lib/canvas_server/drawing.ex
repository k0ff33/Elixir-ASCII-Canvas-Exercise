defmodule CanvasServer.Drawing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drawings" do
    field :drawing, :string
    field :uuid, Ecto.UUID, autogenerate: true

    timestamps()
  end

  @doc false
  def changeset(drawing, attrs) do
    drawing
    |> cast(attrs, [:uuid, :drawing])
    |> validate_required([:uuid, :drawing])
  end
end
