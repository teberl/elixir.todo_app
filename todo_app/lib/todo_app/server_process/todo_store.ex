defmodule TodoApp.ServerProcess.TodoStore do
  @moduledoc """
  Implementation of the TodoApp server using the custom ServerProcess and
  the TodoApp modules.
  """

  alias TodoApp.ServerProcess.Server
  alias TodoApp.{List, Entry}

  # INTERFACE FUNCTIONS FOR THE CLIENT
  def start() do
    Server.start(__MODULE__)
  end

  def get(pid) do
    Server.call(pid, {:get_all})
  end

  def get(pid, %Date{} = date) do
    Server.call(pid, {:get_by_date, date})
  end

  def get(pid, id) do
    Server.call(pid, {:get_by_id, id})
  end

  def put(pid, %Entry{} = entry) do
    Server.cast(pid, {:put, entry})
  end

  def delete(pid, id) do
    Server.cast(pid, {:delete, id})
  end

  # CALLBACK FUNCTIONS USED INTERNALLY BY THE GENERIC CODE
  def init do
    List.new()
  end

  def handle_call({:get_all}, state) do
    {List.get_entries(state), state}
  end

  def handle_call({:get_by_id, id}, state) do
    {List.get_entries(state, id), state}
  end

  def handle_call({:get_by_date, date}, state) do
    {List.get_entries(state, date), state}
  end

  def handle_cast({:put, entry}, state) do
    List.add(state, entry)
  end

  def handle_cast({:delete, id}, state) do
    List.delete_entry(state, id)
  end
end
