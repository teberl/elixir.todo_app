defmodule TodoApp.CacheTest do
  use ExUnit.Case

  alias TodoApp.{Cache, Server, Entry}

  doctest Cache

  test "server_process" do
    {:ok, cache} = Cache.start()

    toms_list = Cache.server_process(cache, "tom")

    assert toms_list != Cache.server_process(cache, "meisi")
    assert toms_list == Cache.server_process(cache, "tom")
  end

  test "todo operations" do
    {:ok, cache} = Cache.start()
    toms_list = Cache.server_process(cache, "tom")
    meisis_list = Cache.server_process(cache, "meisi")
    toms_todo = Entry.new(~D[2018-12-23], "Buy presents!")
    meisis_todo = Entry.new(~D[2018-12-24], "Eat candy!")
    Server.put(toms_list, toms_todo)
    Server.put(meisis_list, meisis_todo)

    assert [%Entry{completed: false, date: ~D[2018-12-23], title: "Buy presents!", id: 1}] ==
             Server.get(toms_list)

    assert [%Entry{completed: false, date: ~D[2018-12-24], title: "Eat candy!", id: 1}] ==
             Server.get(meisis_list)

    Server.put(toms_list, meisis_todo)

    assert [
             %Entry{completed: false, date: ~D[2018-12-23], title: "Buy presents!", id: 1},
             %Entry{completed: false, date: ~D[2018-12-24], title: "Eat candy!", id: 2}
           ] == Server.get(toms_list)

    assert [%Entry{completed: false, date: ~D[2018-12-24], title: "Eat candy!", id: 1}] ==
             Server.get(meisis_list)
  end
end
