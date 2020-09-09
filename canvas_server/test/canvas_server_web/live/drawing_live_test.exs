defmodule CanvasServerWeb.DrawingLiveTest do
  use CanvasServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias CanvasServer.Ascii

  @create_attrs %{drawing: "some drawing"}
  @update_attrs %{drawing: "some updated drawing"}
  @invalid_attrs %{drawing: nil}

  defp fixture(:drawing) do
    {:ok, drawing} = Ascii.create_drawing(@create_attrs)
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

      assert html =~ "Listing Drawings"
      assert html =~ drawing.drawing
    end

    test "saves new drawing", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.drawing_index_path(conn, :index))

      assert index_live |> element("a", "New Drawing") |> render_click() =~
               "New Drawing"

      assert_patch(index_live, Routes.drawing_index_path(conn, :new))

      assert index_live
             |> form("#drawing-form", drawing: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#drawing-form", drawing: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.drawing_index_path(conn, :index))

      assert html =~ "Drawing created successfully"
      assert html =~ "some drawing"
    end

    test "updates drawing in listing", %{conn: conn, drawing: drawing} do
      {:ok, index_live, _html} = live(conn, Routes.drawing_index_path(conn, :index))

      assert index_live |> element("#drawing-#{drawing.id} a", "Edit") |> render_click() =~
               "Edit Drawing"

      assert_patch(index_live, Routes.drawing_index_path(conn, :edit, drawing))

      assert index_live
             |> form("#drawing-form", drawing: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#drawing-form", drawing: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.drawing_index_path(conn, :index))

      assert html =~ "Drawing updated successfully"
      assert html =~ "some updated drawing"
    end

    test "deletes drawing in listing", %{conn: conn, drawing: drawing} do
      {:ok, index_live, _html} = live(conn, Routes.drawing_index_path(conn, :index))

      assert index_live |> element("#drawing-#{drawing.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#drawing-#{drawing.id}")
    end
  end

  describe "Show" do
    setup [:create_drawing]

    test "displays drawing", %{conn: conn, drawing: drawing} do
      {:ok, _show_live, html} = live(conn, Routes.drawing_show_path(conn, :show, drawing))

      assert html =~ "Show Drawing"
      assert html =~ drawing.drawing
    end

    test "updates drawing within modal", %{conn: conn, drawing: drawing} do
      {:ok, show_live, _html} = live(conn, Routes.drawing_show_path(conn, :show, drawing))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Drawing"

      assert_patch(show_live, Routes.drawing_show_path(conn, :edit, drawing))

      assert show_live
             |> form("#drawing-form", drawing: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#drawing-form", drawing: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.drawing_show_path(conn, :show, drawing))

      assert html =~ "Drawing updated successfully"
      assert html =~ "some updated drawing"
    end
  end
end
