defmodule Asciicanvas do
  @moduledoc """
  Documentation for Asciicanvas.
  """

  def draw(input) do
    input
    |> parse_input
    |> create_empty_canvas
    |> draw_rectangle
  end

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

    grid =
      x..(x + width - 1)
      |> Enum.reduce(grid, fn column, map ->
        y..(y + height - 1)
        |> Enum.reduce(map, fn row, map ->
          put_in(map[row][column], outer_char)
        end)
      end)

    result =
      grid
      |> Enum.map(fn {_, x} ->
        x
        |> Enum.map(fn {_, y} -> y end)
        |> Enum.join()
      end)
      |> Enum.join("\n")

    IO.puts(result)
  end

  def create_empty_canvas(
        %Asciicanvas.Options{type: :rectangle, x: x, y: y, width: width, height: height} = options
      ) do
    columns = x + width
    rows = y + height

    canvas =
      0..(rows + 1)
      |> Enum.map(fn x ->
        {x, 0..columns |> Enum.map(fn y -> {y, " "} end) |> Enum.into(%{})}
      end)
      |> Enum.into(%{})

    {canvas, options}
  end

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

    cleanup_regex = ~r/( |`|,|\[|\]|:|character|at|with|\(.+\))/

    case type do
      :rectangle ->
        [_, x, y, "width", width, "height", height, "outline", outline, "fill", fill] =
          String.split(input, cleanup_regex, trim: true)

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
        [_, _, x, y, "fill", fill] = String.split(input, cleanup_regex, trim: true)

        %Asciicanvas.Options{
          type: type,
          x: String.to_integer(x),
          y: String.to_integer(y),
          fill: fill
        }
    end
  end
end
