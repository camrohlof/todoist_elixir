defmodule TodoistElixir.Section do
  alias TodoistElixir.RestClient

  @derive Jason.Encoder
  defstruct [
    :id,
    :project_id,
    :order,
    :name
  ]

  def get(client, id) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/sections/#{id}")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Section)
  end

  def get_all(client) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/sections")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Section)
  end

  def add(client, %TodoistElixir.Section{} = section) do
    RestClient.base_request(client.token)
    |> Req.Request.put_header("Content-Type", "application/json")
    |> Req.post(json: section, url: "/sections")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Section)
  end

  def update(client, %TodoistElixir.Section{} = section, id) do
    RestClient.base_request(client.token)
    |> Req.Request.put_header("Content-Type", "application/json")
    |> Req.post(json: section, url: "/sections/#{id}")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Section)
  end

  def delete(client, id) do
    RestClient.base_request(client.token)
    |> Req.delete(url: "/sections/#{id}")
  end
end
