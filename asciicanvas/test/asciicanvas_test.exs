defmodule AsciicanvasTest do
  use ExUnit.Case
  doctest Asciicanvas

  test "greets the world" do
    assert Asciicanvas.hello() == :world
  end
end
