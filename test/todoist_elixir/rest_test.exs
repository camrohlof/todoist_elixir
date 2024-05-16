defmodule TodoistElixir.RestTest do
  use ExUnit.Case, async: true
  alias TodoistElixir.RestClient
  alias TodoistElixir.Task
  alias TodoistElixir.Project
  alias TodoistElixir.Section
  alias TodoistElixir.Comment
  alias TodoistElixir.Label

  setup_all do
    IO.puts("Starting tests:")
    token = get_token()
    client = RestClient.new(token)

    {:ok, %{token: token, client: client}}
  end

  defp get_token() do
    Application.get_env(:todoist_elixir, TodoistElixir)
    |> Enum.at(0)
    |> elem(1)
  end

  test "Task CRUD test", context do
    client = context[:client]

    assert {:ok, task} = Task.add(client, %Task{content: "TEST"})
    assert {:ok, tasks} = Task.get(client, task.id)
    task = tasks |> Enum.at(0)
    assert {:ok, task} = Task.update(client, %Task{content: "TEST UPDATED", labels: []}, task.id)
    assert {:ok, _} = Task.delete(client, task.id)
  end

  test "Project CRUD test", context do
    client = context[:client]

    assert {:ok, project} = Project.add(client, %Project{name: "TEST"})
    assert {:ok, project} = Project.get(client, project.id)
    assert {:ok, project} = Project.update(client, %Project{name: "TEST UPDATED"}, project.id)
    assert {:ok, _} = Project.delete(client, project.id)
  end

  test "Section CRUD test", context do
    client = context[:client]
    {:ok, projects} = Project.get_all(client)
    project = projects |> Enum.at(0)

    assert {:ok, section} = Section.add(client, %Section{project_id: project.id, name: "TEST"})
    assert {:ok, section} = Section.get(client, section.id)
    assert {:ok, section} = Section.update(client, %Section{name: "TEST UPDATED"}, section.id)
    assert {:ok, _} = Section.delete(client, section.id)
  end

  test "Comment CRUD test", context do
    client = context[:client]
    {:ok, tasks} = Task.get_all(client)
    task = tasks |> Enum.at(0)

    assert {:ok, comment} = Comment.add(client, %Comment{task_id: task.id, content: "TEST"})
    assert {:ok, comment} = Comment.get(client, comment.id)
    assert {:ok, comment} = Comment.update(client, %Comment{content: "TEST UPDATED"}, comment.id)
    assert {:ok, _} = Comment.delete(client, comment.id)
  end

  test "Personal label CRUD test", context do
    client = context[:client]

    assert {:ok, label} = Label.add(client, %Label{name: "TEST"})
    assert {:ok, label} = Label.get(client, label.id)
    assert {:ok, label} = Label.update(client, %Label{name: "TEST UPDATED"}, label.id)
    assert {:ok, _} = Label.delete(client, label.id)
  end
end
