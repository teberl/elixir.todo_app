defmodule TodoApp.Cache do
  use GenServer

  alias TodoApp.{Database, Server}

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(cache_pid, todo_list_name) do
    GenServer.call(cache_pid, {:server_process, todo_list_name})
  end

  @impl GenServer
  def init(_) do
    Database.start()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}

      :error ->
        {:ok, todo_server_pid} = Server.start(todo_list_name)

        {
          :reply,
          todo_server_pid,
          Map.put(todo_servers, todo_list_name, todo_server_pid)
        }
    end
  end
end
