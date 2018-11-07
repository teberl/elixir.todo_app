defmodule TodoApp.List do
  @moduledoc """
  Functions for working with TodoList's
  """
  alias __MODULE__
  alias TodoApp.Todo

  defstruct auto_id: 1, entries: %{}

  @doc """
  Creates an empty or prefilled List

  ## Examples

      iex> TodoApp.List.new()
      %TodoApp.List{auto_id: 1, entries: %{}}

  """
  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %List{},
      &add(&2, &1)
    )
  end

  @doc """
  Adds a todo to an existing list

  ## Examples

      iex> List.new() |> List.add(Todo.new(~D[1984-01-01], "Buy tomatoes."))
      %List{
        auto_id: 2,
        entries: %{
          1 => %Todo{
            completed: false,
            date: ~D[1984-01-01],
            id: 1,
            title: "Buy tomatoes."
          }
        }
      }

  """
  def add(
        %List{auto_id: auto_id, entries: entries} = _,
        %Todo{} = entry
      ) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)

    %List{entries: new_entries, auto_id: auto_id + 1}
  end
end
