defmodule TodoApp.Database do
  use GenServer

  @db_folder "./file_storage"

  def start, do: GenServer.start(__MODULE__, nil, name: __MODULE__)
  def get(key), do: GenServer.call(__MODULE__, {:get, key})
  def store(key, data), do: GenServer.cast(__MODULE__, {:store, key, data})

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, nil}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, state) do
    spawn(fn ->
      key
      |> file_name()
      |> File.write!(:erlang.term_to_binary(data))
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:get, key}, caller, state) do
    spawn(fn ->
      data =
        case File.read(file_name(key)) do
          {:ok, contents} -> :erlang.binary_to_term(contents)
          _ -> nil
        end

      GenServer.reply(caller, data)
    end)

    {:noreply, state}
  end

  defp file_name(key), do: Path.join(@db_folder, to_string(key))
end
