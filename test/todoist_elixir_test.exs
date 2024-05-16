defmodule TodoistElixirTest do
  use ExUnit.Case
  doctest TodoistElixir

  test "greets the world" do
    assert TodoistElixir.hello() == :world
  end
end
