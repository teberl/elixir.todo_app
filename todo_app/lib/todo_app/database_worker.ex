defmodule TodoApp.DatabaseWorker do
  use GenServer

  def start_link({db_folder, worker_id}) do
    IO.puts("Starting database worker No.#{worker_id}")

    GenServer.start_link(
      __MODULE__,
      db_folder,
      name: via_tuple(worker_id)
    )
  end

  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
  end

  def store(worker_id, key, data) do
    GenServer.cast(via_tuple(worker_id), {:store, key, data})
  end

  @impl GenServer
  def init(db_folder) do
    File.mkdir_p!(db_folder)
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    spawn(fn ->
      key
      |> file_name(db_folder)
      |> File.write!(:erlang.term_to_binary(data))
    end)

    {:noreply, db_folder}
  end

  @impl GenServer
  def handle_call({:get, key}, caller, db_folder) do
    spawn(fn ->
      data =
        case File.read(file_name(key, db_folder)) do
          {:ok, contents} -> :erlang.binary_to_term(contents)
          _ -> nil
        end

      GenServer.reply(caller, data)
    end)

    {:noreply, db_folder}
  end

  defp via_tuple(worker_id) do
    TodoApp.ProcessRegistry.via_tuple({__MODULE__, worker_id})
  end

  defp file_name(key, db_folder), do: Path.join(db_folder, to_string(key))
end
