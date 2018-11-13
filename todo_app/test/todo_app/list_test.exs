defmodule TodoApp.ListTest do
  use ExUnit.Case
  alias TodoApp.{List, Todo}

  doctest List

  test "new/0 creates an empty %TodoApp.List{}" do
    assert List.new() == %List{auto_id: 1, entries: %{}}
  end

  test "add/2 adds a todo to an existing list" do
    expected_result = %List{
      auto_id: 3,
      entries: %{
        1 => %Todo{
          completed: false,
          date: ~D[1984-01-01],
          id: 1,
          title: "Buy tomatoes."
        },
        2 => %Todo{
          completed: false,
          date: ~D[1984-01-01],
          id: 2,
          title: "Buy cucumbers."
        }
      }
    }

    assert List.new()
           |> List.add(Todo.new(~D[1984-01-01], "Buy tomatoes."))
           |> List.add(Todo.new(~D[1984-01-01], "Buy cucumbers.")) == expected_result
  end

  test "Enum.into/2 adds the todos to the list" do
    todos = [
      Todo.new(~D[1984-01-01], "Buy fish."),
      Todo.new(~D[1984-01-01], "Buy chips."),
      Todo.new(~D[1984-01-01], "Buy beer.")
    ]

    expected_result = %List{
      auto_id: 4,
      entries: %{
        1 => %Todo{
          completed: false,
          date: ~D[1984-01-01],
          id: 1,
          title: "Buy fish."
        },
        2 => %Todo{
          completed: false,
          date: ~D[1984-01-01],
          id: 2,
          title: "Buy chips."
        },
        3 => %Todo{
          completed: false,
          date: ~D[1984-01-01],
          id: 3,
          title: "Buy beer."
        }
      }
    }

    assert Enum.into(todos, List.new()) == expected_result
  end
end
