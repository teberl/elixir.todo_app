# TodoApp

Supervised system with a basic file based database system for dynamically creating todo lists by spawning up processes.  
Big thx to [Saša Jurić](https://twitter.com/sasajuric) and his book [elixir in action](https://www.manning.com/books/elixir-in-action-second-edition)  

## Testing our TodoApp system

`➜  todo_app git:(master) ✗ iex -S mix`

Starting the System

```elixir
iex(1)> TodoApp.System.start_link
iex(2)> TodoApp.System.start_link
Starting database worker No.1
Starting database worker No.2
Starting database worker No.3
Starting cache
{:ok, #PID<0.144.0>}
```

Receiving a todo_app __pid__ from the cache  
(Creates dynamic supervised Todo_App.Server processes)
```elixir
iex(3)> toms_list = TodoApp.Cache.server_process("toms_list")
Starting server for toms_list
#PID<0.153.0>
```

Starting the same process again  
(Since the cache starts named processes, we will receive the same pid if we ask the cache again for __toms_list__ without starting a new process)
```elixir
iex(4)> toms_list = TodoApp.Cache.server_process("toms_list")
#PID<0.153.0>
```

A new name will provide a new __pid__
```elixir
iex(5)> meisis_list = TodoApp.Cache.server_process("meisis_list")
Starting server for meisis_list
#PID<0.157.0>
```

Discovering processes from the __Registry__ module  
`@spec lookup(registry(), key()) :: [{pid(), value()}]`
```elixir
iex(9)> Registry.lookup(TodoApp.ProcessRegistry, {TodoApp.Server, "meisis_list"})
[{#PID<0.157.0>, nil}]
iex(10)> Registry.lookup(TodoApp.ProcessRegistry, {TodoApp.Server, "toms_list"})
[{#PID<0.153.0>, nil}]
iex(11)> Registry.lookup(TodoApp.ProcessRegistry, {TodoApp.Server, "bobs_list"})
[]
```

Killing a TodoApp.Server  
(After killing the process we receive empty array from the lookup, a restart of the process will assign a new __pid__)  
```elixir
iex(12)> Process.exit(toms_list, :kill)
true
iex(13)> Registry.lookup(TodoApp.ProcessRegistry, {TodoApp.Server, "toms_list"})
[]
iex(14)> toms_list = TodoApp.Cache.server_process("toms_list")
Starting server for toms_list
#PID<0.169.0>
```

get, put, delete entries to a list with the __TodoApp.Server__ module

```elixir
iex(19)> TodoApp.Server.put(toms_list, Entry.new(~D[2018-11-11], "Write a better documentation."))
:ok

iex(23)> TodoApp.Server.get(toms_list)
[
  %TodoApp.Entry{
    completed: false,
    date: ~D[2018-11-11],
    id: 1,
    title: "Write a better documentation."
  }
]

iex(24)> TodoApp.Server.delete(toms_list, 1)
:ok

iex(25)> TodoApp.Server.get(toms_list)
[]

iex(26)> TodoApp.Server.put(toms_list, Entry.new(~D[2018-11-11], "Write a better documentation."))
:ok
iex(27)> TodoApp.Server.put(toms_list, Entry.new(~D[2018-12-12], "Program more elixir."))
:ok

iex(30)> TodoApp.Server.get(toms_list, ~D[2018-12-12])
[
  %TodoApp.Entry{
    completed: false,
    date: ~D[2018-12-12],
    id: 4,
    title: "Program more elixir."
  }
]

iex(31)> TodoApp.Server.get(toms_list, 3)
[
  %TodoApp.Entry{
    completed: false,
    date: ~D[2018-11-11],
    id: 3,
    title: "Write a better documentation."
  }
]
```

## TodoApp.{List, Entry} interface examples

You can create entries and lists by using the corresponding modules

```elixir
iex(1)> alias TodoApp.{List, Entry}
[TodoApp.List, TodoApp.Entry]

iex(2)> todo = Entry.new(~D[2018-11-11], "Write a better documentation.")
%TodoApp.Entry{
  completed: false,
  date: ~D[2018-11-11],
  id: nil,
  title: "Write a better documentation."
}

iex(3)> List.new
%TodoApp.List{auto_id: 1, entries: %{}}

iex(5)> List.new([todo])
%TodoApp.List{
  auto_id: 2,
  entries: %{
    1 => %TodoApp.Todo{
      completed: false,
      date: ~D[2018-11-11],
      id: 1,
      title: "Write a better documentation."
    }
  }
}

iex(6)> todos = [Entry.new(~D[2018-11-11], "Foo"), Entry.new(~D[2018-11-11], "Bar")]
[
  %TodoApp.Todo{completed: false, date: ~D[2018-11-11], id: nil, title: "Foo"},
  %TodoApp.Todo{completed: false, date: ~D[2018-11-11], id: nil, title: "Bar"}
]

iex(7)> List = List.new |> List.add(Entry.new(~D[2011-01-01], "Buy tomatoes."))
%TodoApp.List{
  auto_id: 2,
  entries: %{
    1 => %TodoApp.Entry{
      completed: false,
      date: ~D[2011-01-01],
      id: 1,
      title: "Buy tomatoes."
    }
  }
}

iex(8)> Enum.into(List, [Entry.new(~D[2011-01-01], "Buy Beer.")])
%TodoApp.List{
  auto_id: 3,
  entries: %{
    1 => %TodoApp.Entry{
      completed: false,
      date: ~D[1984-01-01],
      id: 1,
      title: "Buy tomatoes."
    },
    2 => %TodoApp.Entry{
      completed: false,
      date: ~D[2011-01-01],
      id: 2,
      title: "Buy Beer."
    }
  }
}

iex(9)> for todo <- todos, into: List.new, do: todo
%TodoApp.List{
  auto_id: 3,
  entries: %{
    1 => %TodoApp.Entry{
      completed: false,
      date: ~D[2018-11-11],
      id: 1,
      title: "Foo"
    },
    2 => %TodoApp.Entry{
      completed: false,
      date: ~D[2018-11-11],
      id: 2,
      title: "Bar"
    }
  }
}

iex(10)> todos |> List.get_entries(~D[1984-01-01])
[
  %TodoApp.Entry{
    completed: false,
    date: ~D[1984-01-01],
    id: 1,
    title: "Buy tomatoes."
  }
]

```