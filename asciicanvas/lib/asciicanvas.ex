defmodule Asciicanvas do
  @moduledoc """
  Documentation for Asciicanvas.
  """

  @doc """
  Parse ASCII canvas command into machine-readable format

  ## Examples

      iex> Asciicanvas.parse_input("Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `@`, fill character: `X`")
      %{
        fill: "X",
        height: "3",
        outline: "@",
        type: :rectangle,
        width: "5",
        x: "3",
        y: "2"
      }
  """
  def parse_input(input) do
    type =
      Regex.run(~r/^\w+/, input)
      |> hd
      |> String.downcase()
      |> String.to_atom()

    [x, y] =
      String.replace(input, ~r{(.+\[|\].+| )}, "")
      |> String.split(",")

    extract_property = fn input, property ->
      clean_regex = ~r/(`| |:|character)/

      String.replace(input, clean_regex, "")
      |> String.replace(~r/(.+#{property}|,.+)/, "")
    end

    width = extract_property.(input, "width")
    height = extract_property.(input, "height")
    outline = extract_property.(input, "outline")
    fill = extract_property.(input, "fill")

    %{type: type, x: x, y: y, width: width, height: height, outline: outline, fill: fill}
  end
end
