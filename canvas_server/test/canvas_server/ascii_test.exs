defmodule CanvasServer.AsciiTest do
  use CanvasServer.DataCase

  alias CanvasServer.Ascii

  describe "drawings" do
    alias CanvasServer.Ascii.Drawing

    @valid_attrs %{drawing: "some drawing"}
    @update_attrs %{drawing: "some updated drawing"}
    @invalid_attrs %{drawing: nil}

    def drawing_fixture(attrs \\ %{}) do
      {:ok, drawing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ascii.create_drawing()

      drawing
    end

    test "list_drawings/0 returns all drawings" do
      drawing = drawing_fixture()
      assert Ascii.list_drawings() == [drawing]
    end

    test "get_drawing!/1 returns the drawing with given id" do
      drawing = drawing_fixture()
      assert Ascii.get_drawing!(drawing.id) == drawing
    end

    test "create_drawing/1 with valid data creates a drawing" do
      assert {:ok, %Drawing{} = drawing} = Ascii.create_drawing(@valid_attrs)
      assert drawing.drawing == "some drawing"
    end

    test "create_drawing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ascii.create_drawing(@invalid_attrs)
    end

    test "update_drawing/2 with valid data updates the drawing" do
      drawing = drawing_fixture()
      assert {:ok, %Drawing{} = drawing} = Ascii.update_drawing(drawing, @update_attrs)
      assert drawing.drawing == "some updated drawing"
    end

    test "update_drawing/2 with invalid data returns error changeset" do
      drawing = drawing_fixture()
      assert {:error, %Ecto.Changeset{}} = Ascii.update_drawing(drawing, @invalid_attrs)
      assert drawing == Ascii.get_drawing!(drawing.id)
    end

    test "delete_drawing/1 deletes the drawing" do
      drawing = drawing_fixture()
      assert {:ok, %Drawing{}} = Ascii.delete_drawing(drawing)
      assert_raise Ecto.NoResultsError, fn -> Ascii.get_drawing!(drawing.id) end
    end

    test "change_drawing/1 returns a drawing changeset" do
      drawing = drawing_fixture()
      assert %Ecto.Changeset{} = Ascii.change_drawing(drawing)
    end
  end
end
