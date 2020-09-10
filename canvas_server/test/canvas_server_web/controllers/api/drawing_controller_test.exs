defmodule CanvasServerWeb.Api.DrawingControllerTest do
  use CanvasServerWeb.ConnCase

  alias CanvasServer.Art

  @create_attrs %{
    drawing:
      "\n\n   @@@@@\n   @XXX@  XXXXXXXXXXXXXX\n   @@@@@  XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XXXXXXXXXXXXXX"
  }
  @valid_operations %{
    operations: [
      "Rectangle at `[14, 0]` with width `7`, height `6`, outline character: none, fill: `.`",
      "Rectangle at `[0, 3]` with width `8`, height `4`, outline character: `O`, fill: `none`",
      "Rectangle at `[5, 5]` with width `5`, height `3`, outline character: `X`, fill: `X`",
      "Flood fill at `[0, 0]` with fill character `-` (canvas presented in 32x12 size)"
    ]
  }
  @invalid_operations %{
    operations: ["Circle at `[5, 6]` with radius: `2`"]
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

    test "lists all drawings", %{conn: conn} do
      conn = get(conn, Routes.drawing_path(conn, :index))

      assert [%{"drawing" => drawing, "id" => id}] = json_response(conn, 200)["data"]

      assert drawing ==
               "\n\n   @@@@@\n   @XXX@  XXXXXXXXXXXXXX\n   @@@@@  XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XXXXXXXXXXXXXX"

      assert is_bitstring(id)
    end
  end

  describe "Show" do
    setup [:create_drawing]

    test "displays drawing", %{conn: conn, drawing: drawing} do
      conn = get(conn, Routes.drawing_path(conn, :show, drawing))

      assert %{"drawing" => drawing, "id" => id} = json_response(conn, 200)["data"]

      assert drawing ==
               "\n\n   @@@@@\n   @XXX@  XXXXXXXXXXXXXX\n   @@@@@  XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XXXXXXXXXXXXXX"
    end
  end

  describe "Create" do
    test "successfully creates new drawing", %{conn: conn} do
      conn = post(conn, Routes.drawing_path(conn, :create), @valid_operations)

      assert %{"message" => message} = json_response(conn, 200)

      assert message == "Drawing created successfully"
    end

    test "rejects invalid draw operations", %{conn: conn} do
      conn = post(conn, Routes.drawing_path(conn, :create), @invalid_operations)

      assert %{"error" => error} = json_response(conn, 400)

      assert error == "unsupported draw operation"
    end
  end
end
