defmodule AntzTest do
  use ExUnit.Case
  doctest Antz

  test "greets the world" do
    assert Antz.hello() == :world
  end
end
