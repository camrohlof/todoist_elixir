defmodule TodoistElixir.Comment do
  alias TodoistElixir.RestClient

  @derive Jason.Encoder
  defstruct [
    :content,
    :id,
    :posted_at,
    :project_id,
    :task_id,
    :attachment
  ]

  def get(client, id) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/comments/#{id}")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Comment)
  end

  def get_all(client, {:task_id, id}) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/comments", path_params: [task_id: id])
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Comment)
  end

  def get_all(client, {:project_id, id}) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/comments", path_params: [project_id: id])
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Comment)
  end

  def add(client, comment) do
    RestClient.base_request(client.token)
    |> Req.Request.put_header("X-Request-Id", "$(#{Ecto.UUID.generate()})")
    |> Req.post(json: comment, url: "/comments")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Comment)
  end

  def update(client, comment, id) do
    RestClient.base_request(client.token)
    |> Req.Request.put_header("X-Request-Id", "$(#{Ecto.UUID.generate()})")
    |> Req.post(json: comment, url: "/comments/#{id}")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Comment)
  end

  def delete(client, id) do
    RestClient.base_request(client.token)
    |> Req.delete(url: "/comments/#{id}")
  end
end
