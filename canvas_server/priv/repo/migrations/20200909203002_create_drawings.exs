defmodule CanvasServer.Repo.Migrations.CreateDrawings do
  use Ecto.Migration

  def change do
    create table(:drawings, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :drawing, :text

      timestamps()
    end
  end
end
