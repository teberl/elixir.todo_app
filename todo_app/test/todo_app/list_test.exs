defmodule TodoApp.ListTest do
  use ExUnit.Case
  alias TodoApp.{List, Todo}

  doctest List

  test "new/0 creates an empty %TodoApp.List{}" do
    assert List.new() == %List{auto_id: 1, entries: %{}}
  end

  test "add/2 adds a todo to an existing list" do
    assert List.new()
           |> List.add(Todo.new(~D[1984-01-01], "Buy tomatoes."))
           |> List.add(Todo.new(~D[1984-01-01], "Buy cucumbers.")) ==
             %List{
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
  end
end
