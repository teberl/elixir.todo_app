# TodoApp

Provides an API to intract with TodoLists and TodoEntries

Supported Features are:

* Creating new Lists and Entries with **List.new/0** and **Todo.new/0**
* Adding Entries with **List.add/2**

## Some examples for usage in iex

After starting the mix project in iex inside the todo_app dir with

```➜  todo_app git:(master) ✗ iex -S mix```

you can use the api

```elixir

iex(1)> alias TodoApp.Todo
TodoApp.Todo

iex(2)> alias TodoApp.List, as: TodoList

iex(3)> todo = Todo.new(~D[2018-11-11], "Write a better documentation.")
%TodoApp.Todo{
  completed: false,
  date: ~D[2018-11-11],
  id: nil,
  title: "Write a better documentation."
}

iex(4)> TodoList.new
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

iex(6)> todos = [Todo.new(~D[2018-11-11], "Foo"), Todo.new(~D[2018-11-11], "Bar")]
[
  %TodoApp.Todo{completed: false, date: ~D[2018-11-11], id: nil, title: "Foo"},
  %TodoApp.Todo{completed: false, date: ~D[2018-11-11], id: nil, title: "Bar"}
]

iex(7)> todoList = TodoList.new |> TodoList.add(Todo.new(~D[2011-01-01], "Buy tomatoes."))
%TodoApp.List{
  auto_id: 2,
  entries: %{
    1 => %TodoApp.Todo{
      completed: false,
      date: ~D[2011-01-01],
      id: 1,
      title: "Buy tomatoes."
    }
  }
}

iex(8)> Enum.into(todoList, [Todo.new(~D[2011-01-01], "Buy Beer.")])
%TodoApp.List{
  auto_id: 3,
  entries: %{
    1 => %TodoApp.Todo{
      completed: false,
      date: ~D[1984-01-01],
      id: 1,
      title: "Buy tomatoes."
    },
    2 => %TodoApp.Todo{
      completed: false,
      date: ~D[2011-01-01],
      id: 2,
      title: "Buy Beer."
    }
  }
}

iex(9)> for todo <- todos, into: TodoList.new, do: todo
%TodoApp.List{
  auto_id: 3,
  entries: %{
    1 => %TodoApp.Todo{
      completed: false,
      date: ~D[2018-11-11],
      id: 1,
      title: "Foo"
    },
    2 => %TodoApp.Todo{
      completed: false,
      date: ~D[2018-11-11],
      id: 2,
      title: "Bar"
    }
  }
}

```