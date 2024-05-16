defmodule TodoistElixir.Task do
  alias TodoistElixir.RestClient

  @derive Jason.Encoder
  defstruct [
    :creator_id,
    :created_at,
    :assignee_id,
    :assigner_id,
    :comment_count,
    :is_completed,
    :content,
    :description,
    :due,
    :duration,
    :id,
    :labels,
    :order,
    :priority,
    :project_id,
    :section_id,
    :parent_id,
    :url
  ]

  def get(client, id) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/tasks", params: [ids: id])
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Task)
  end

  def get_all(client) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/tasks")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Task)
  end

  def add(client, %TodoistElixir.Task{} = task) do
    RestClient.base_request(client.token)
    |> Req.Request.put_header("X-Request-Id", "$(#{Ecto.UUID.generate()})")
    |> Req.post(json: task, url: "/tasks")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Task)
  end

  def update(client, %TodoistElixir.Task{} = task, id) do
    RestClient.base_request(client.token)
    |> Req.Request.put_header("X-Request-Id", "$(#{Ecto.UUID.generate()})")
    |> Req.post(json: task, url: "/tasks/#{id}")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Task)
  end

  def close(client, id) do
    RestClient.base_request(client.token)
    |> Req.post(url: "/tasks/#{id}/close")
  end

  def reopen(client, id) do
    RestClient.base_request(client.token)
    |> Req.post(url: "/tasks/#{id}/reopen")
  end

  def delete(client, id) do
    RestClient.base_request(client.token)
    |> Req.delete(url: "/tasks/#{id}")
  end
end
