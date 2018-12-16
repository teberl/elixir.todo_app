# TodoApp

Provides an API to intract with Lists and TodoEntries

Supported Features are:

* Creating new Lists and entries with **List.new/0**/**List.new/1** and **Entry.new/0**
* Adding a single entry with **List.add/2**
* Adding multiple entries from a collectable with **Enum.into/2**
* Getting a list of all entries from a List with **List.get_entries/1**
* Getting a list of entries matching by date or id with **List.get_entries/2**

## Some code examples in iex

After starting the mix project in iex inside the todo_app dir with

`➜  todo_app git:(master) ✗ iex -S mix`

Usage of the basic TodoApp interface

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