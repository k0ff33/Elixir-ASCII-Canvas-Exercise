defmodule CanvasServerWeb.DrawingLiveTest do
  use CanvasServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias CanvasServer.Art

  @create_attrs %{
    drawing:
      "\n\n   @@@@@\n   @XXX@  XXXXXXXXXXXXXX\n   @@@@@  XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XXXXXXXXXXXXXX"
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
end
