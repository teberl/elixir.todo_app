defmodule TodoApp.Database do
  use GenServer

  alias TodoApp.DatabaseWorker

  @db_folder "./file_storage"

  def start, do: GenServer.start(__MODULE__, nil, name: __MODULE__)

  def get(key) do
    key
    |> choose_worker
    |> DatabaseWorker.get(key)
  end

  def store(key, data) do
    key
    |> choose_worker
    |> DatabaseWorker.store(key, data)
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, start_workers()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _from, workers) do
    worker = :erlang.phash2(key, 3)
    {:reply, Map.get(workers, worker), workers}
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  defp start_workers() do
    for index <- 0..2, into: %{} do
      {:ok, pid} = DatabaseWorker.start(@db_folder)
      {index, pid}
    end
  end
end
