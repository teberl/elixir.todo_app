defmodule TodoApp.ListTest do
  use ExUnit.Case
  alias TodoApp.{List, Todo}

  doctest List

  @todo_one %Todo{
    completed: false,
    date: ~D[1984-01-01],
    id: 1,
    title: "Buy tomatoes."
  }

  @todo_two %Todo{
    completed: false,
    date: ~D[1984-01-01],
    id: 2,
    title: "Buy cucumbers."
  }

  test "new/0 creates an empty %TodoApp.List{}" do
    assert List.new() == %List{auto_id: 1, entries: %{}}
  end

  test "new/1 creates a %TodoApp.List{} with the %Todo{}'s from the list'" do
    expected_result = %List{
      auto_id: 3,
      entries: %{
        1 => @todo_one,
        2 => @todo_two
      }
    }

    assert List.new([@todo_one, @todo_two]) == expected_result
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
