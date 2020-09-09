defmodule CanvasServer.Repo.Migrations.CreateDrawings do
  use Ecto.Migration

  def change do
    create table(:drawings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :drawing, :text

      timestamps()
    end

  end
end
