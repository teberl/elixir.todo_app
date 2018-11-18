defmodule TodoApp.SimpleServer do
  alias TodoApp.{TodoList, TodoEntry}

  def start do
    spawn(fn -> loop(TodoList.new()) end)
  end

  def add_entry(todo_server, %TodoEntry{} = new_entry) do
    send(todo_server, {:add_entry, new_entry})
  end

  def get_entries(todo_server) do
    send(todo_server, {:get_entries, self()})

    receive do
      {:todo_list, todo_list} ->
        get_description_text(todo_list)
    end
  end

  def get_entries(todo_server, %Date{} = date) do
    send(todo_server, {:get_entries, self(), date})

    receive do
      {:todo_list, todo_list} ->
        get_description_text(todo_list)
    end
  end

  defp loop(todo_list) do
    new_todo_list =
      receive do
        message ->
          process_message(todo_list, message)
      end

    loop(new_todo_list)
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    todo_list
    |> TodoList.add(new_entry)
  end

  defp process_message(todo_list, {:get_entries, caller}) do
    send(caller, {:todo_list, TodoList.get_entries(todo_list)})
    todo_list
  end

  defp process_message(todo_list, {:get_entries, caller, date}) do
    todos_by_date = TodoList.get_entries(todo_list, date)
    send(caller, {:todo_list, todos_by_date})
    todo_list
  end

  defp process_message(todo_list, _) do
    todo_list
  end

  defp get_description_text(entries) do
    entries
    |> Enum.map(&"#{&1.title} until #{Date.to_iso8601(&1.date)}")
  end
end
