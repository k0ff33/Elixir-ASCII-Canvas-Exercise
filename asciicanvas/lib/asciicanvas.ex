defmodule Asciicanvas do
  @moduledoc """
  Documentation for Asciicanvas.
  """

  @doc """
  Parse ASCII canvas command into machine-readable format

  ## Examples

      iex> Asciicanvas.parse_input("Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `@`, fill character: `X`")
      %{
        "fill" => "X",
        "height" => "3",
        "outline" => "@",
        "type" => "Rectangle",
        "width" => "5",
        "x" => "3",
        "y" => "2"
      }
  """
  def parse_input(input) do
    regex =
      ~r/(?<type>\w+)\[(?<x>.+),(?<y>.+)\].+width:(?<width>.+).+height:(?<height>.+).+outline:(?<outline>.+).+fill:(?<fill>.+)/

    String.replace(input, " ", "")
    |> String.replace("`", "")
    |> String.replace("at", "")
    |> String.replace("character", "")
    |> (&Regex.named_captures(
          regex,
          &1
        )).()
  end
end
