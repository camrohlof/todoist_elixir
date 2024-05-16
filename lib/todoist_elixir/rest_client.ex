defmodule TodoistElixir.RestClient do
  @type t() :: %{token: String.t()}

  def base_url() do
    "https://api.todoist.com/rest/v2"
  end

  @spec new(String.t()) :: TodoistElixir.RestClient.t()
  def new(token) do
    # Auth will come here
    %{token: token}
  end

  def base_request(token) do
    Req.new(base_url: TodoistElixir.RestClient.base_url())
    |> Req.Request.put_header("Authorization", "Bearer #{token}")
  end

  def map_to_struct({:ok, data}, struct_type) when is_list(data) do
    data =
      data
      |> Enum.map(fn x -> struct(struct_type, x) end)

    {:ok, data}
  end

  def map_to_struct({:ok, data}, struct_type), do: {:ok, struct(struct_type, data)}

  def map_to_struct({:error, error}, _struct_type), do: {:error, error}

  defp map_to_data(map) when is_list(map) do
    data =
      map
      |> Enum.map(fn x ->
        Enum.reduce(x, %{}, fn {k, v}, acc ->
          Map.put(acc, String.to_existing_atom(k), v)
        end)
      end)

    {:ok, data}
  end

  defp map_to_data(map) do
    data =
      map
      |> Enum.reduce(%{}, fn {k, v}, acc ->
        Map.put(acc, String.to_existing_atom(k), v)
      end)

    {:ok, data}
  end

  def response_to_map({:ok, data}) when data.status in 200..299 do
    data.body
    |> map_to_data()
  end

  def response_to_map({:ok, data}) when data.status > 300, do: {:error, data.body}

  def response_to_map({:error, error}), do: {:error, error}
end
