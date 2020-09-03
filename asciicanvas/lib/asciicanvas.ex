defmodule Asciicanvas do
  @moduledoc """
  Documentation for Asciicanvas.
  """

  @doc """
  Parse ASCII canvas command into machine-readable format

  ## Examples

      iex> Asciicanvas.parse_input("Rectangle at `[3,2]` with width: `5`, height: `3`, outline character: `@`, fill character: `X`")
      {:ok,
        %{
          fill: "X",
          height: 3,
          outline: "@",
          type: :rectangle,
          width: 5,
          x: 3,
          y: 2
        }
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

        {:ok,
         %{
           type: type,
           x: String.to_integer(x),
           y: String.to_integer(y),
           width: String.to_integer(width),
           height: String.to_integer(height),
           outline: outline,
           fill: fill
         }}
    end
  end
end
