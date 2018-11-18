defmodule TodoApp.TodoListTest do
  use ExUnit.Case
  alias TodoApp.{TodoList, TodoEntry}

  doctest TodoList

  @todo_one %TodoEntry{
    completed: false,
    date: ~D[1984-01-01],
    id: 1,
    title: "Buy tomatoes."
  }

  @todo_two %TodoEntry{
    completed: false,
    date: ~D[1984-01-01],
    id: 2,
    title: "Buy cucumbers."
  }

  test "new/0 creates an empty %TodoList{}" do
    assert TodoList.new() == %TodoList{auto_id: 1, entries: %{}}
  end

  test "new/1 creates a %TodoList{} with the %TodoEntry{}'s from the list'" do
    expected_result = %TodoList{
      auto_id: 3,
      entries: %{
        1 => @todo_one,
        2 => @todo_two
      }
    }

    assert TodoList.new([@todo_one, @todo_two]) == expected_result
  end

  test "add/2 adds a %TodoEntry{} to an existing %TodoList{}" do
    expected_result = %TodoList{
      auto_id: 3,
      entries: %{
        1 => %TodoEntry{
          completed: false,
          date: ~D[1984-01-01],
          id: 1,
          title: "Buy tomatoes."
        },
        2 => %TodoEntry{
          completed: false,
          date: ~D[1984-01-01],
          id: 2,
          title: "Buy cucumbers."
        }
      }
    }

    assert TodoList.new()
           |> TodoList.add(TodoEntry.new(~D[1984-01-01], "Buy tomatoes."))
           |> TodoList.add(TodoEntry.new(~D[1984-01-01], "Buy cucumbers.")) == expected_result
  end

  test "Enum.into/2 adds the %TodoEntry{}'s to the %TodoList{}" do
    todos = [
      TodoEntry.new(~D[1984-01-01], "Buy fish."),
      TodoEntry.new(~D[1984-01-01], "Buy chips."),
      TodoEntry.new(~D[1984-01-01], "Buy beer.")
    ]

    expected_result = %TodoList{
      auto_id: 4,
      entries: %{
        1 => %TodoEntry{
          completed: false,
          date: ~D[1984-01-01],
          id: 1,
          title: "Buy fish."
        },
        2 => %TodoEntry{
          completed: false,
          date: ~D[1984-01-01],
          id: 2,
          title: "Buy chips."
        },
        3 => %TodoEntry{
          completed: false,
          date: ~D[1984-01-01],
          id: 3,
          title: "Buy beer."
        }
      }
    }

    assert Enum.into(todos, TodoList.new()) == expected_result
  end

  test "TodoList.delete/2 deletes the corresponding %TodoEntry{} from the %TodoList{}" do
    todos = [
      TodoEntry.new(~D[1984-01-01], "Buy fish."),
      TodoEntry.new(~D[1984-01-01], "Buy chips."),
      TodoEntry.new(~D[1984-01-01], "Buy beer.")
    ]

    expected_result = %TodoList{
      auto_id: 4,
      entries: %{
        1 => %TodoEntry{
          completed: false,
          date: ~D[1984-01-01],
          id: 1,
          title: "Buy fish."
        },
        3 => %TodoEntry{
          completed: false,
          date: ~D[1984-01-01],
          id: 3,
          title: "Buy beer."
        }
      }
    }

    assert TodoList.new(todos)
           |> TodoList.delete_entry(2) == expected_result
  end
end
