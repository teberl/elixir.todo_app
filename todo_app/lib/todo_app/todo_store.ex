defmodule TodoApp.TodoStore do
  alias __MODULE__
  alias TodoApp.{ServerProcess, TodoList, TodoEntry}

  # INTERFACE FUNCTIONS FOR THE CLIENT
  def start() do
    ServerProcess.start(TodoStore)
  end

  def get(pid) do
    ServerProcess.call(pid, {:get_all})
  end

  def get(pid, id) do
    ServerProcess.call(pid, {:get_by_id, id})
  end

  def get(pid, %Date{} = date) do
    ServerProcess.call(pid, {:get_by_date, date})
  end

  def put(pid, %TodoEntry{} = entry) do
    ServerProcess.cast(pid, {:put, entry})
  end

  def delete(pid, id) do
    ServerProcess.cast(pid, {:delete, id})
  end

  # CALLBACK FUNCTIONS USED INTERNALLY BY THE GENERIC CODE
  def init do
    TodoList.new()
  end

  def handle_call({:get_all}, state) do
    {TodoList.get_entries(state), state}
  end

  def handle_call({:get_by_id, id}, state) do
    {TodoList.get_entries(state, id), state}
  end

  def handle_call({:get_by_date, date}, state) do
    {TodoList.get_entries(state, id), state}
  end

  def handle_cast({:put, entry}, state) do
    TodoList.add(state, entry)
  end

  def handle_cast({:delete, id}, state) do
    TodoList.delete_entry(state, id)
  end
end
