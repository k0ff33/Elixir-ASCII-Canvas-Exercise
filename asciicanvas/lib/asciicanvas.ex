defmodule Asciicanvas do
  @moduledoc """
  Documentation for Asciicanvas.
  """

  @doc """
  Draw ASCII image based on passed commands

  ## Examples

    iex> Asciicanvas.draw([ "Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `@`, fill character: `X`", "Rectangle at [10, 3] with width: 14, height: 6, outline character: `X`, fill character: `O`" ])
    "

   @@@@@@
   @XXXX@ XXXXXXXXXXXXXXX
   @XXXX@ XOOOOOOOOOOOOOX
   @@@@@@ XOOOOOOOOOOOOOX
          XOOOOOOOOOOOOOX
          XOOOOOOOOOOOOOX
          XOOOOOOOOOOOOOX
          XXXXXXXXXXXXXXX
                         "
  """
  def draw(commands) do
    parsed_cmds = Enum.map(commands, fn input -> parse_input(input) end)

    width =
      Enum.map(parsed_cmds, fn %Asciicanvas.Options{x: x, width: width} -> x + width end)
      |> Enum.max()

    height =
      Enum.map(parsed_cmds, fn %Asciicanvas.Options{y: y, height: height} -> y + height end)
      |> Enum.max()

    Enum.reduce(parsed_cmds, create_empty_canvas(width, height), fn cmd, canvas ->
      draw_rectangle({canvas, cmd})
    end)
    |> print
  end

  def print(grid) do
    result =
      grid
      |> Enum.map(fn {_, x} ->
        x
        |> Enum.map(fn {_, y} -> y end)
        |> Enum.join()
      end)
      |> Enum.join("\n")

    IO.puts(result)
    result
  end

  @spec draw_rectangle({any, Asciicanvas.Options.t()}) :: any
  def draw_rectangle(
        {grid,
         %Asciicanvas.Options{
           x: x,
           y: y,
           width: width,
           height: height,
           outline: outline,
           fill: fill
         }}
      ) do
    outer_char = if outline !== "none", do: outline, else: fill
    inner_char = if fill !== "none", do: fill, else: " "

    is_edge? = fn
      column, row when row >= x and (column == y or column == y + height) -> true
      column, row when column >= y and (row == x or row === x + width) -> true
      _column, _row -> false
    end

    x..(x + width)
    |> Enum.reduce(grid, fn row, map ->
      y..(y + height)
      |> Enum.reduce(map, fn column, map ->
        char = if is_edge?.(column, row), do: outer_char, else: inner_char

        put_in(map[column][row], char)
      end)
    end)
  end

  def create_empty_canvas(columns, rows) do
    0..(rows + 1)
    |> Enum.map(fn x ->
      {x, 0..columns |> Enum.map(fn y -> {y, " "} end) |> Enum.into(%{})}
    end)
    |> Enum.into(%{})
  end

  @spec parse_input(binary) :: Asciicanvas.Options.t()
  @doc """
  Parse ASCII canvas command into machine-readable format

  ## Examples

      iex> Asciicanvas.parse_input("Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `@`, fill character: `X`")
      %Asciicanvas.Options{
        fill: "X",
        height: 3,
        outline: "@",
        type: :rectangle,
        width: 5,
        x: 3,
        y: 2
      }
  """
  def parse_input(input) do
    type =
      Regex.run(~r/\w+/, input)
      |> hd
      |> String.downcase()
      |> String.to_atom()

    ascii_regex = ~r/\b\d+\b|\b\w\b|`[[:print:]]`|none/u

    case type do
      :rectangle ->
        [x, y, width, height, outline, fill] =
          Regex.scan(ascii_regex, input)
          |> Enum.map(fn [str] -> String.replace(str, "`", "") end)

        %Asciicanvas.Options{
          type: type,
          x: String.to_integer(x),
          y: String.to_integer(y),
          width: String.to_integer(width),
          height: String.to_integer(height),
          outline: outline,
          fill: fill
        }

      :flood ->
        [x, y, fill] =
          Regex.scan(ascii_regex, input)
          |> Enum.map(fn [str] -> String.replace(str, "`", "") end)

        %Asciicanvas.Options{
          type: type,
          x: String.to_integer(x),
          y: String.to_integer(y),
          fill: fill
        }
    end
  end
end
