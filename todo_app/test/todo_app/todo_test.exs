defmodule TodoApp.TodoTest do
  use ExUnit.Case
  alias TodoApp.Todo

  doctest Todo

  test "new/2 creates a %Todo{}" do
    assert Todo.new(~D[1984-01-01], "Buy tomatoes.") == %Todo{
             completed: false,
             date: ~D[1984-01-01],
             id: nil,
             title: "Buy tomatoes."
           }
  end

  test "new/2 raises an error for invalid or missing arguments" do
    assert_raise UndefinedFunctionError, fn -> Todo.new() end
    assert_raise FunctionClauseError, fn -> Todo.new("1984-01-01", "Buy tomatoes.") end
    assert_raise FunctionClauseError, fn -> Todo.new(~D[1984-01-01], :tomatoes) end
  end
end
