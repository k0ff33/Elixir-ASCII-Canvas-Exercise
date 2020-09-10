defmodule CanvasServer.AsciiTest do
  use CanvasServer.DataCase

  alias CanvasServer.Art

  describe "drawings" do
    alias CanvasServer.Art.Drawing

    @valid_attrs %{drawing: "some drawing"}
    @update_attrs %{drawing: "some updated drawing"}
    @invalid_attrs %{drawing: nil}

    def drawing_fixture(attrs \\ %{}) do
      {:ok, drawing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Art.create_drawing()

      drawing
    end

    test "list_drawings/0 returns all drawings" do
      drawing = drawing_fixture()
      assert Art.list_drawings() == [drawing]
    end

    test "get_drawing!/1 returns the drawing with given id" do
      drawing = drawing_fixture()
      assert Art.get_drawing!(drawing.id) == drawing
    end

    test "create_drawing/1 with valid data creates a drawing" do
      assert {:ok, %Drawing{} = drawing} = Art.create_drawing(@valid_attrs)
      assert drawing.drawing == "some drawing"
    end

    test "create_drawing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Art.create_drawing(@invalid_attrs)
    end
  end
end
