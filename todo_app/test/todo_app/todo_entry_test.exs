defmodule TodoApp.TodoEntryTest do
  use ExUnit.Case
  alias TodoApp.TodoEntry

  doctest TodoEntry

  test "new/2 creates a %TodoEntry{}" do
    assert TodoEntry.new(~D[1984-01-01], "Buy tomatoes.") == %TodoEntry{
             completed: false,
             date: ~D[1984-01-01],
             id: nil,
             title: "Buy tomatoes."
           }
  end

  test "new/2 raises an error for invalid or missing arguments" do
    assert_raise UndefinedFunctionError, fn -> TodoEntry.new() end
    assert_raise FunctionClauseError, fn -> TodoEntry.new("1984-01-01", "Buy tomatoes.") end
    assert_raise FunctionClauseError, fn -> TodoEntry.new(~D[1984-01-01], :tomatoes) end
  end
end
