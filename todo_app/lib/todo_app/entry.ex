defmodule TodoApp.Entry do
  @moduledoc false

  alias __MODULE__

  defstruct id: nil, date: nil, title: nil, completed: nil

  @doc """
  Creates a new Entry

  ## Examples

      iex> Entry.new(~D[1984-01-01], "Buy tomatoes.")
      %Entry{completed: false, date: ~D[1984-01-01], id: nil, title: "Buy tomatoes."}

  """
  def new(%Date{} = date, title) when is_binary(title) do
    %Entry{date: date, title: title, completed: false}
  end
end
