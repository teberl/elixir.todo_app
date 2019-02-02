defmodule TodoApp.Server do
  use GenServer, restart: :temporary

  alias TodoApp.{Entry, List, Database, ProcessRegistry}

  def start_link(list_name) do
    GenServer.start_link(
      __MODULE__,
      list_name,
      name: via_tuple(list_name)
    )
  end

  def put(pid, %Entry{} = entry), do: GenServer.cast(pid, {:put, entry})

  def get(pid), do: GenServer.call(pid, {:get_all})
  def get(pid, id) when is_integer(id), do: GenServer.call(pid, {:get_by_id, id})
  def get(pid, %Date{} = date), do: GenServer.call(pid, {:get_by_date, date})
  def get(pid, _), do: GenServer.call(pid, {:get_all})

  def delete(pid, id) when is_integer(id), do: GenServer.cast(pid, {:delete, id})

  @impl GenServer
  def init(list_name) do
    IO.puts("Starting server for #{list_name}")

    send(self(), {:real_init, list_name})
    {:ok, nil}
  end

  @impl GenServer
  def handle_info({:real_init, list_name}, _state) do
    {:noreply, {list_name, Database.get(list_name) || List.new()}}
  end

  @impl GenServer
  def handle_cast({:put, entry}, {list_name, entries}) do
    new_list = List.add(entries, entry)
    Database.store(list_name, new_list)
    {:noreply, {list_name, new_list}}
  end

  @impl GenServer
  def handle_cast({:delete, id}, {list_name, entries}) do
    new_list = List.delete_entry(entries, id)
    Database.store(list_name, new_list)
    {:noreply, {list_name, new_list}}
  end

  @impl GenServer
  def handle_call({:get_all}, _, {_list_name, entries} = state) do
    {:reply, List.get_entries(entries), state}
  end

  @impl GenServer
  def handle_call({:get_by_date, date}, _, {_list_name, entries} = state) do
    {:reply, List.get_entries(entries, date), state}
  end

  @impl GenServer
  def handle_call({:get_by_id, id}, _, {_list_name, entries} = state) do
    {:reply, List.get_entries(entries, id), state}
  end

  defp via_tuple(name) do
    ProcessRegistry.via_tuple({__MODULE__, name})
  end
end
