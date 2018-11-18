defmodule TodoApp.TodoList do
  @moduledoc """
  Functions for working with TodoList's
  """

  alias __MODULE__
  alias TodoApp.TodoEntry

  defstruct auto_id: 1, entries: %{}

  @doc """
  Creates an empty or prefilled TodoList

  ## Examples

    iex> TodoApp.TodoList.new()
    %TodoApp.TodoList{auto_id: 1, entries: %{}}

  """
  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      &add(&2, &1)
    )
  end

  @doc """
  Adds a todo to an existing TodoList and return the updated TodoList

  ## Examples

    iex> TodoApp.TodoList.new() |> TodoApp.TodoList.add(TodoApp.TodoEntry.new(~D[1984-01-01], "Buy tomatoes."))
    %TodoList{
      auto_id: 2,
      entries: %{
        1 => %TodoEntry{
          completed: false,
          date: ~D[1984-01-01],
          id: 1,
          title: "Buy tomatoes."
        }
      }
    }

  """
  def add(
        %TodoList{auto_id: auto_id, entries: entries} = _,
        %TodoEntry{} = entry
      ) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)

    %TodoList{entries: new_entries, auto_id: auto_id + 1}
  end

  @doc """
  Get returns a list of todos from an existing list

  * get_entries/1 returns a list of todos from a todo_list
  * get_entries/2 returns a list of all todos matching an id or a date

  ## Examples
    iex> todo_list = TodoApp.TodoList.new() |> TodoApp.TodoList.add(TodoApp.TodoEntry.new(~D[1984-01-01], "Buy tomatoes."))
    iex> todo_list |> TodoList.get_entries
    [
      %TodoApp.TodoEntry{
        completed: false,
        date: ~D[1984-01-01],
        id: 1,
        title: "Buy tomatoes."
      }
    ]

    iex> todo_list = TodoApp.TodoList.new() |> TodoApp.TodoList.add(TodoApp.TodoEntry.new(~D[1984-01-01], "Buy tomatoes."))
    iex> todo_list |> TodoList.get_entries(1)
    [
      %TodoApp.TodoEntry{
        completed: false,
        date: ~D[1984-01-01],
        id: 1,
        title: "Buy tomatoes."
      }
    ]

    iex> todo_list = TodoApp.TodoList.new() |> TodoApp.TodoList.add(TodoApp.TodoEntry.new(~D[1984-01-01], "Buy tomatoes."))
    iex> todo_list |> TodoList.get_entries(~D[1984-01-01])
    [
      %TodoApp.TodoEntry{
        completed: false,
        date: ~D[1984-01-01],
        id: 1,
        title: "Buy tomatoes."
      }
    ]

  """
  def get_entries(%TodoList{entries: todos} = _) do
    Enum.map(todos, fn {_, todo} -> todo end)
  end

  def get_entries(%TodoList{entries: todos} = _, id) when is_integer(id) do
    todos
    |> Stream.filter(fn {_, todo} -> todo.id == id end)
    |> Enum.map(fn {_, todo} -> todo end)
  end

  def get_entries(%TodoList{entries: todos} = _, %Date{} = date) do
    todos
    |> Stream.filter(fn {_, todo} -> todo.date == date end)
    |> Enum.map(fn {_, todo} -> todo end)
  end

  def delete_entry(%TodoList{auto_id: auto_id, entries: todos}, id) when is_integer(id) do
    new_todos = Map.delete(todos, id)
    %TodoList{auto_id: auto_id, entries: new_todos}
  end

  defimpl Collectable do
    def into(original) do
      into_callback = fn
        list, {:cont, todo} -> TodoList.add(list, todo)
        list, :done -> list
        _list, :halt -> :ok
      end

      {original, into_callback}
    end
  end
end
