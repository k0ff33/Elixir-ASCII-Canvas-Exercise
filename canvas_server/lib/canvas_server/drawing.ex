defmodule CanvasServer.Drawing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drawings" do
    field :drawing, :string
    field :uid, Ecto.UUID, autogenerate: true

    timestamps()
  end

  @doc false
  def changeset(drawing, attrs) do
    drawing
    |> cast(attrs, [:uid, :drawing])
    |> validate_required([:uid, :drawing])
  end
end
