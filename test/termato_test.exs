defmodule TermatoTest do
  use ExUnit.Case
  doctest Termato

  test "greets the world" do
    assert Termato.hello() == :world
  end
end
