defmodule TodoApp.Todo do
  @moduledoc false

  alias __MODULE__

  defstruct id: nil, date: nil, title: nil, completed: nil

  @doc """
  Creates a new Todo

  ## Examples

      iex> Todo.new(~D[1984-01-01], "Buy tomatoes.")
      %Todo{completed: false, date: ~D[1984-01-01], id: nil, title: "Buy tomatoes."}

  """
  def new(%Date{} = date, title) when is_binary(title) do
    %Todo{date: date, title: title, completed: false}
  end
end
