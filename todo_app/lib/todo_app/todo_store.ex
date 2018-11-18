defmodule TodoApp.TodoStore do
  alias __MODULE__
  alias TodoApp.{ServerProcess, TodoList, TodoEntry}

  def start() do
    ServerProcess.start(TodoStore)
  end

  def get(pid) do
    ServerProcess.call(pid, {:get})
  end

  def get(pid, id) do
    ServerProcess.call(pid, {:get, id})
  end

  def put(pid, %TodoEntry{} = entry) do
    ServerProcess.call(pid, {:put, entry})
  end

  def init do
    TodoList.new()
  end

  def handle_call({:get}, state) do
    {TodoList.get_entries(state), state}
  end

  def handle_call({:get, id}, state) do
    {TodoList.get_entries(state, id), state}
  end

  def handle_call({:put, entry}, state) do
    {:ok, TodoList.add(state, entry)}
  end
end
