defmodule CanvasServer.Art.Drawing do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:id, :drawing]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "drawings" do
    field :drawing, :string

    timestamps()
  end

  @doc false
  def changeset(drawing, attrs) do
    drawing
    |> cast(attrs, [:drawing])
    |> validate_required([:drawing])
  end
end
