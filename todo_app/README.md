# TodoApp

Provides an API to intract with TodoLists and TodoEntries

Supported Features are:

* Creating new Lists and entries with **TodoList.new/0**/**TodoList.new/1** and **TodoEntry.new/0**
* Adding single entry with **TodoList.add/2**
* Adding multiple entries from a collectable with **Enum.into/2**
* Getting a list of all entries from a TodoList with **TodoList.get/1**
* Getting a list of entries matching by date or id with **TodoList.get/2**

## Some code examples in iex

After starting the mix project in iex inside the todo_app dir with

```➜  todo_app git:(master) ✗ iex -S mix```

you can use the api

```elixir

iex(1)> alias TodoApp.{TodoList, TodoEntry}
[TodoApp.TodoList, TodoApp.TodoEntry]

iex(2)> todo = TodoEntry.new(~D[2018-11-11], "Write a better documentation.")
%TodoApp.TodoEntry{
  completed: false,
  date: ~D[2018-11-11],
  id: nil,
  title: "Write a better documentation."
}

iex(3)> TodoList.new
%TodoApp.List{auto_id: 1, entries: %{}}

iex(5)> TodoList.new([todo])
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

iex(6)> todos = [TodoEntry.new(~D[2018-11-11], "Foo"), TodoEntry.new(~D[2018-11-11], "Bar")]
[
  %TodoApp.Todo{completed: false, date: ~D[2018-11-11], id: nil, title: "Foo"},
  %TodoApp.Todo{completed: false, date: ~D[2018-11-11], id: nil, title: "Bar"}
]

iex(7)> todoList = TodoList.new |> TodoList.add(TodoEntry.new(~D[2011-01-01], "Buy tomatoes."))
%TodoApp.TodoList{
  auto_id: 2,
  entries: %{
    1 => %TodoApp.TodoEntry{
      completed: false,
      date: ~D[2011-01-01],
      id: 1,
      title: "Buy tomatoes."
    }
  }
}

iex(8)> Enum.into(todoList, [TodoEntry.new(~D[2011-01-01], "Buy Beer.")])
%TodoApp.TodoList{
  auto_id: 3,
  entries: %{
    1 => %TodoApp.TodoEntry{
      completed: false,
      date: ~D[1984-01-01],
      id: 1,
      title: "Buy tomatoes."
    },
    2 => %TodoApp.TodoEntry{
      completed: false,
      date: ~D[2011-01-01],
      id: 2,
      title: "Buy Beer."
    }
  }
}

iex(9)> for todo <- todos, into: TodoList.new, do: todo
%TodoApp.TodoList{
  auto_id: 3,
  entries: %{
    1 => %TodoApp.TodoEntry{
      completed: false,
      date: ~D[2018-11-11],
      id: 1,
      title: "Foo"
    },
    2 => %TodoApp.TodoEntry{
      completed: false,
      date: ~D[2018-11-11],
      id: 2,
      title: "Bar"
    }
  }
}

iex(10)> todos |> TodoList.get(~D[1984-01-01])
[
  %TodoApp.TodoEntry{
    completed: false,
    date: ~D[1984-01-01],
    id: 1,
    title: "Buy tomatoes."
  }
]

```