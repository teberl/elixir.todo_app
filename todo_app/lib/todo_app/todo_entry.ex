defmodule TodoApp.TodoEntry do
  @moduledoc false

  alias __MODULE__

  defstruct id: nil, date: nil, title: nil, completed: nil

  @doc """
  Creates a new TodoEntry

  ## Examples

      iex> TodoEntry.new(~D[1984-01-01], "Buy tomatoes.")
      %TodoEntry{completed: false, date: ~D[1984-01-01], id: nil, title: "Buy tomatoes."}

  """
  def new(%Date{} = date, title) when is_binary(title) do
    %TodoEntry{date: date, title: title, completed: false}
  end
end
