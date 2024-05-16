defmodule TodoistElixir.Label do
  alias TodoistElixir.RestClient

  defstruct [
    :id,
    :name,
    :color,
    :order,
    :is_favorite
  ]

  defimpl Jason.Encoder, for: TodoistElixir.Label do
    def encode(value, opts) do
      value
      |> Map.from_struct()
      |> Map.reject(fn {_k, v} -> is_nil(v) end)
      |> Jason.Encode.map(opts)
    end
  end

  def get(client, id) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/labels/#{id}")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Label)
  end

  def get_all(client) do
    RestClient.base_request(client.token)
    |> Req.get(url: "/labels")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Label)
  end

  def add(client, %TodoistElixir.Label{} = label) do
    RestClient.base_request(client.token)
    |> Req.Request.put_header("Content-Type", "application/json")
    |> Req.post(json: label, url: "/labels")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Label)
  end

  def update(client, %TodoistElixir.Label{} = label, id) do
    RestClient.base_request(client.token)
    |> Req.Request.put_header("Content-Type", "application/json")
    |> Req.post(json: label, url: "/labels/#{id}")
    |> RestClient.response_to_map()
    |> RestClient.map_to_struct(TodoistElixir.Label)
  end

  def delete(client, id) do
    RestClient.base_request(client.token)
    |> Req.delete(url: "/labels/#{id}")
  end
end
