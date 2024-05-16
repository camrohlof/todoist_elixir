defmodule TodoistElixir.Project do
  alias TodoistElixir.RestClient

  defstruct [
    :id,
    :name,
    :comment_count,
    :order,
    :color,
    :is_shared,
    :is_favorite,
    :parent_id,
    :is_inbox_project,
    :is_team_inbox,
    :view_style,
    :url
  ]

  defimpl Jason.Encoder, for: TodoistElixir.Project do
    def encode(value, opts) do
      value
      |> Map.from_struct()
      |> Map.reject(fn {_k, v} -> is_nil(v) end)
      |> Jason.Encode.map(opts)
    end
  end

  def get(client, id) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/projects/#{id}")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Project)
  end

  def get_all(client) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/projects")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Project)
  end

  def get_collaborators(client, id) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/projects/#{id}/collaborators")
  end

  def add(client, %TodoistElixir.Project{} = project) do
    RestClient.base_request(client.token)
    |> Req.Request.put_header("X-Request-Id", "$(#{Ecto.UUID.generate()})")
    |> Req.post(json: project, url: "/projects")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Project)
  end

  def update(client, %TodoistElixir.Project{} = project, id) do
    RestClient.base_request(client.token)
    |> Req.Request.put_header("X-Request-Id", "$(#{Ecto.UUID.generate()})")
    |> Req.post(json: project, url: "/projects/#{id}")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Project)
  end

  def delete(client, id) do
    RestClient.base_request(client.token)
    |> Req.delete(url: "/projects/#{id}")
  end
end
