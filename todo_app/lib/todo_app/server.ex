defmodule TodoApp.Server do
  use GenServer

  alias TodoApp.{Entry, List}

  def start(), do: GenServer.start(__MODULE__, nil, [])

  def put(pid, %Entry{} = entry), do: GenServer.cast(pid, {:put, entry})

  def get(pid), do: GenServer.call(pid, {:get_all})
  def get(pid, id) when is_integer(id), do: GenServer.call(pid, {:get_by_id, id})
  def get(pid, %Date{} = date), do: GenServer.call(pid, {:get_by_date, date})
  def get(pid, _), do: GenServer.call(pid, {:get_all})

  def delete(pid, id) when is_integer(id), do: GenServer.cast(pid, {:delete, id})

  @impl GenServer
  def init(_args) do
    {:ok, List.new()}
  end

  @impl GenServer
  def handle_cast({:put, entry}, state) do
    {:noreply, List.add(state, entry)}
  end

  @impl GenServer
  def handle_cast({:delete, id}, state) do
    {:noreply, List.delete_entry(state, id)}
  end

  @impl GenServer
  def handle_call({:get_all}, _, state) do
    {:reply, List.get_entries(state), state}
  end

  @impl GenServer
  def handle_call({:get_by_date, date}, _, state) do
    {:reply, List.get_entries(state, date), state}
  end

  @impl GenServer
  def handle_call({:get_by_id, id}, _, state) do
    {:reply, List.get_entries(state, id), state}
  end
end
