defmodule GoopTest do
  use ExUnit.Case
  doctest Goop

  test "greets the world" do
    assert Goop.hello() == :world
  end
end
