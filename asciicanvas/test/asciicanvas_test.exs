defmodule AsciicanvasTest do
  use ExUnit.Case
  doctest Asciicanvas

  describe "input parsing:" do
    test "invalid shape - circle" do
      assert_raise ArgumentError, fn ->
        Asciicanvas.parse_input(
          "Circle at [3,2] with radius: 5, outline character: `@`, fill character: `X`"
        )
      end
    end

    test "invalid command - too many arguments" do
      assert_raise MatchError, fn ->
        Asciicanvas.parse_input(
          "Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `none`, fill character: `none`, outline: `X`"
        )
      end
    end

    test "test fixture 1, command 1" do
      canvas_options =
        Asciicanvas.parse_input(
          "Rectangle at [3,2] with width: 5, height: 3, outline character: `@`, fill character: `X`"
        )

      assert canvas_options ==
               %Asciicanvas.Options{
                 fill: "X",
                 height: 3,
                 outline: "@",
                 type: :rectangle,
                 width: 5,
                 x: 3,
                 y: 2
               }
    end

    test "test fixture 1, command 2" do
      canvas_options =
        Asciicanvas.parse_input(
          "Rectangle at [10, 3] with width: 14, height: 6, outline character: `X`, fill character: `O`"
        )

      assert canvas_options ==
               %Asciicanvas.Options{
                 fill: "O",
                 height: 6,
                 outline: "X",
                 type: :rectangle,
                 width: 14,
                 x: 10,
                 y: 3
               }
    end

    test "test fixture 2, command 1" do
      canvas_options =
        Asciicanvas.parse_input(
          "Rectangle at `[14, 0]` with width `7`, height `6`, outline character: none, fill: `.`"
        )

      assert canvas_options ==
               %Asciicanvas.Options{
                 fill: ".",
                 height: 6,
                 outline: "none",
                 type: :rectangle,
                 width: 7,
                 x: 14,
                 y: 0
               }
    end

    test "test fixture 2, command 2" do
      canvas_options =
        Asciicanvas.parse_input(
          "Rectangle at `[0, 3]` with width `8`, height `4`, outline character: `O`, fill: `none`"
        )

      assert canvas_options ==
               %Asciicanvas.Options{
                 fill: "none",
                 height: 4,
                 outline: "O",
                 type: :rectangle,
                 width: 8,
                 x: 0,
                 y: 3
               }
    end

    test "test fixture 2, command 3" do
      canvas_options =
        Asciicanvas.parse_input(
          "Rectangle at `[5, 5]` with width `5`, height `3`, outline character: `X`, fill: `X`"
        )

      assert canvas_options ==
               %Asciicanvas.Options{
                 fill: "X",
                 height: 3,
                 outline: "X",
                 type: :rectangle,
                 width: 5,
                 x: 5,
                 y: 5
               }
    end

    test "test fixture 3, command 1" do
      canvas_options =
        Asciicanvas.parse_input(
          "Rectangle at `[14, 0]` with width `7`, height `6`, outline character: none, fill: `.`"
        )

      assert canvas_options ==
               %Asciicanvas.Options{
                 fill: ".",
                 height: 6,
                 outline: "none",
                 type: :rectangle,
                 width: 7,
                 x: 14,
                 y: 0
               }
    end

    test "test fixture 3, command 2" do
      canvas_options =
        Asciicanvas.parse_input(
          "Rectangle at `[0, 3]` with width `8`, height `4`, outline character: `O`, fill: `none`"
        )

      assert canvas_options ==
               %Asciicanvas.Options{
                 fill: "none",
                 height: 4,
                 outline: "O",
                 type: :rectangle,
                 width: 8,
                 x: 0,
                 y: 3
               }
    end

    test "test fixture 3, command 3" do
      canvas_options =
        Asciicanvas.parse_input(
          "Rectangle at `[5, 5]` with width `5`, height `3`, outline character: `X`, fill: `X`"
        )

      assert canvas_options ==
               %Asciicanvas.Options{
                 fill: "X",
                 height: 3,
                 outline: "X",
                 type: :rectangle,
                 width: 5,
                 x: 5,
                 y: 5
               }
    end

    test "test fixture 3, command 4" do
      canvas_options =
        Asciicanvas.parse_input(
          "Flood fill at `[0, 0]` with fill character `-` (canvas presented in 32x12 size)"
        )

      assert canvas_options ==
               %Asciicanvas.Options{
                 fill: "-",
                 height: nil,
                 outline: nil,
                 type: :flood,
                 width: nil,
                 x: 0,
                 y: 0
               }
    end
  end

  describe "drawing ASCII canvas:" do
    test "invalid shape - circle" do
      {:error, message} =
        Asciicanvas.draw([
          "Circle at `[3,2]"
        ])

      assert message == "unsupported draw operation"
    end

    test "invalid shape - rectangle without outline or fill" do
      {:error, message} =
        Asciicanvas.draw([
          "Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `none`, fill character: `none`"
        ])

      assert message == "either fill or outline should always be present"
    end

    test "invalid command - too many arguments" do
      {:error, message} =
        Asciicanvas.draw([
          "Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `none`, fill character: `none`, outline: `X`"
        ])

      assert message == "too many or not enought arguments provided"
    end

    test "single rectangle" do
      {:ok, shape} =
        Asciicanvas.draw([
          "Rectangle at `[3,8]` with width: `14`, height: `6`, outline character: `~`, fill character: `none`"
        ])

      assert shape ==
               "\n\n\n\n\n\n\n\n   ~~~~~~~~~~~~~~\n   ~            ~\n   ~            ~\n   ~            ~\n   ~            ~\n   ~~~~~~~~~~~~~~"
    end

    test "test fixture 1" do
      {:ok, shape} =
        Asciicanvas.draw([
          "Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `@`, fill character: `X`",
          "Rectangle at [10, 3] with width: 14, height: 6, outline character: `X`, fill character: `O`"
        ])

      assert shape ==
               "\n\n   @@@@@\n   @XXX@  XXXXXXXXXXXXXX\n   @@@@@  XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX\n          XXXXXXXXXXXXXX"
    end

    test "test fixture 2" do
      {:ok, shape} =
        Asciicanvas.draw([
          "Rectangle at `[14, 0]` with width `7`, height `6`, outline character: none, fill: `.`",
          "Rectangle at `[0, 3]` with width `8`, height `4`, outline character: `O`, fill: `none`",
          "Rectangle at `[5, 5]` with width `5`, height `3`, outline character: `X`, fill: `X`"
        ])

      assert shape ==
               "              .......\n              .......\n              .......\nOOOOOOOO      .......\nO      O      .......\nO    XXXXX    .......\nOOOOOXXXXX\n     XXXXX"
    end

    test "test fixture 3" do
      {:ok, shape} =
        Asciicanvas.draw([
          "Rectangle at `[14, 0]` with width `7`, height `6`, outline character: none, fill: `.`",
          "Rectangle at `[0, 3]` with width `8`, height `4`, outline character: `O`, fill: `none`",
          "Rectangle at `[5, 5]` with width `5`, height `3`, outline character: `X`, fill: `X`",
          "Flood fill at `[0, 0]` with fill character `-` (canvas presented in 32x12 size)"
        ])

      assert shape ==
               "--------------.......\n--------------.......\n--------------.......\nOOOOOOOO------.......\nO      O------.......\nO    XXXXX----.......\nOOOOOXXXXX-----------\n     XXXXX-----------"
    end

    test "inverted test fixture 3" do
      {:ok, shape} =
        Asciicanvas.draw([
          "Flood fill at `[0, 0]` with fill character `-` (canvas presented in 32x12 size)",
          "Rectangle at `[5, 5]` with width `5`, height `3`, outline character: `X`, fill: `X`",
          "Rectangle at `[0, 3]` with width `8`, height `4`, outline character: `O`, fill: `none`",
          "Rectangle at `[14, 0]` with width `7`, height `6`, outline character: none, fill: `.`"
        ])

      assert shape ==
               "--------------.......\n--------------.......\n--------------.......\nOOOOOOOO------.......\nO      O------.......\nO      OXX----.......\nOOOOOOOOXX-----------\n-----XXXXX-----------"
    end
  end
end
