defmodule CanvasServerWeb.DrawingLiveTest do
  use CanvasServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias CanvasServer.Art

  @create_attrs %{
    drawing:
      "\n\n   @@@@@\n   @XXX@  XXXXXXXXXXXXXX\n   @@@@@  XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XXXXXXXXXXXXXX"
  }
  @post_operations %{
    operations: [
      "Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `@`, fill character: `X`",
      "Rectangle at [10, 3] with width: 14, height: 6, outline character: `X`, fill character: `O`"
    ]
  }

  defp fixture(:drawing) do
    {:ok, drawing} = Art.create_drawing(@create_attrs)
    drawing
  end

  defp create_drawing(_) do
    drawing = fixture(:drawing)
    %{drawing: drawing}
  end

  describe "Index" do
    setup [:create_drawing]

    test "lists all drawings", %{conn: conn, drawing: drawing} do
      {:ok, _index_live, html} = live(conn, Routes.drawing_index_path(conn, :index))

      assert html =~ "Latest drawings"
      assert html =~ drawing.drawing
    end
  end

  describe "Show" do
    setup [:create_drawing]

    test "displays drawing", %{conn: conn, drawing: drawing} do
      {:ok, _show_live, html} = live(conn, Routes.drawing_show_path(conn, :show, drawing))

      assert html =~ "Drawing"
      assert html =~ drawing.drawing
    end
  end

  describe "Create" do
    test "new drawings are automatically displayed", %{conn: conn} do
      conn = post(conn, Routes.drawing_path(conn, :create), @post_operations)
      {:ok, index_live, _html} = live(conn, Routes.drawing_index_path(conn, :index))

      assert %{"message" => message, "data" => drawing} = json_response(conn, 200)
      assert message == "Drawing created successfully"
      assert has_element?(index_live, "#drawing-#{drawing["id"]}")
    end
  end
end
