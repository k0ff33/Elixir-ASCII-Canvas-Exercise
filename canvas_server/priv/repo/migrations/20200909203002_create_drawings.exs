defmodule CanvasServer.Repo.Migrations.CreateDrawings do
  use Ecto.Migration

  def change do
    create table(:drawings) do
      add :uid, :uuid
      add :drawing, :text

      timestamps()
    end
  end
end
