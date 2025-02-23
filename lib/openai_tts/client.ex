defmodule OpenaiTTS.Client do
  @moduledoc """
  A client module for interacting with the OpenAI API using HTTP requests.
  Provides helper functions for making GET and POST requests.
  """

  alias HTTPoison
  alias Jason
  alias OpenaiTTS.Config

  @base_url "https://api.openai.com"

  @headers [
    {"Content-Type", "application/json"},
    {"Authorization", "Bearer #{Config.api_key()}"}
  ]

  @doc """
  Constructs a full URL for a given API endpoint.

  ## Examples

      iex> OpenaiTTS.Client.url("/v1/audio/speech")
      "https://api.openai.com/v1/audio/speech"
  """
  def url(endpoint), do: @base_url <> endpoint

  @doc """
  Sends a POST request to the specified API endpoint with the given body.

  ## Examples

      iex> OpenaiTTS.Client.post("/v1/speech", %{text: "Hello"})
      {:ok, response_body}
  """
  def post(endpoint, body) do
    HTTPoison.post(
      url(endpoint),
      Jason.encode!(body),
      @headers
    )
    |> handle_response()
  end

  @doc """
  Sends a GET request to the specified API endpoint.

  ## Examples

      iex> OpenaiTTS.Client.get("/v1/models")
      {:ok, response_body}
  """
  def get(endpoint) do
    HTTPoison.get(
      url(endpoint),
      @headers
    )
    |> handle_response()
  end

  @doc """
  Handles HTTP responses, returning `{:ok, body}` for successful responses
  and `{:error, reason}` for failed ones.

  ## Examples

      iex> OpenaiTTS.Client.handle_response({:ok, %HTTPoison.Response{status_code: 200, body: "success"}})
      {:ok, "success"}
  """
  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}) when status_code in 200..226 do
    {:ok, body}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: _status_code, body: body}}) do
    IO.puts("Request failed: #{body}")
    {:error, body}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    reason =
      Jason.decode!(reason)
      |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
      |> Map.new()

    {:error, reason}
  end
end
