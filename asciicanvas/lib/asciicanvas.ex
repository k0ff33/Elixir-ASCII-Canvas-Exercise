defmodule Asciicanvas do
  @moduledoc """
  Documentation for Asciicanvas.
  """

  @doc """
  Draw ASCII image based on passed commands

  ## Examples

      Asciicanvas.draw([ "Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `@`, fill character: `X`", "Rectangle at [10, 3] with width: 14, height: 6, outline character: `X`, fill character: `O`" ])

  """
  def draw(commands) do
    parsed_cmds = Enum.map(commands, fn input -> parse_input(input) end)

    %{:width => width, :height => height} = calculate_canvas_dimensions(parsed_cmds)
    empty_canvas = create_empty_canvas(width, height)

    Enum.reduce(parsed_cmds, empty_canvas, fn cmd, canvas -> draw_shape(canvas, cmd) end)
    |> print
  end

  def print(grid) do
    result =
      Enum.map_join(grid, "\n", fn {_, x} ->
        x
        |> Enum.map_join(fn {_, y} -> y end)
      end)

    IO.puts(result)

    result
  end

  def draw_shape(
        grid,
        %Asciicanvas.Options{type: :flood, x: column, y: row, fill: fill} = options
      ) do
    case grid[column][row] do
      " " ->
        put_in(grid[column][row], fill)
        |> draw_shape(%Asciicanvas.Options{options | y: row + 1})
        |> draw_shape(%Asciicanvas.Options{options | y: row - 1})
        |> draw_shape(%Asciicanvas.Options{options | x: column + 1})
        |> draw_shape(%Asciicanvas.Options{options | x: column - 1})

      _ ->
        grid
    end
  end

  def draw_shape(
        grid,
        %Asciicanvas.Options{
          type: :rectangle,
          x: x,
          y: y,
          width: width,
          height: height,
          outline: outline,
          fill: fill
        }
      ) do
    outer_char = if outline !== "none", do: outline, else: fill
    inner_char = if fill !== "none", do: fill, else: " "

    shape_width = x + width - 1
    shape_height = y + height - 1

    is_edge? = fn
      column, row when row >= x and (column == y or column == shape_height) -> true
      column, row when column >= y and (row == x or row === shape_width) -> true
      _column, _row -> false
    end

    x..shape_width
    |> Enum.reduce(grid, fn row, map ->
      y..shape_height
      |> Enum.reduce(map, fn column, map ->
        char = if is_edge?.(column, row), do: outer_char, else: inner_char

        put_in(map[column][row], char)
      end)
    end)
  end

  def create_empty_canvas(columns, rows) do
    0..(rows - 1)
    |> Enum.map(fn x ->
      {x, 0..(columns - 1) |> Enum.map(fn y -> {y, " "} end) |> Enum.into(%{})}
    end)
    |> Enum.into(%{})
  end

  def calculate_canvas_dimensions(parsed_cmds) do
    Enum.reduce(parsed_cmds, %{width: 0, height: 0}, fn
      %Asciicanvas.Options{type: :rectangle, x: x, y: y, width: width, height: height},
      dimensions ->
        dimensions
        |> put_in([:width], max(dimensions[:width], x + width))
        |> put_in([:height], max(dimensions[:height], y + height))

      %Asciicanvas.Options{type: :flood, x: x, y: y}, dimensions ->
        dimensions
        |> put_in([:width], max(dimensions[:width], x))
        |> put_in([:height], max(dimensions[:height], y))

      _, dimensions ->
        dimensions
    end)
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
