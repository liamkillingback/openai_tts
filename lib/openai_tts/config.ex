defmodule OpenaiTTS.Config do
  @moduledoc """
  The `OpenaiTTS.Config` module manages configuration settings for OpenAI's TTS API.

  It uses a `GenServer` to store and retrieve configuration values dynamically.
  Configuration values can be provided via the application environment or system environment variables.
  """

  use GenServer

  defstruct api_key: nil,
            http_options: nil

  @config_keys [
    :api_key,
    :http_options
  ]

  @doc """
  Starts the configuration GenServer.

  ## Parameters
  - `opts` (keyword list): Options for initialization.

  ## Returns
  - `{:ok, pid}` on success.

  ## Example
      iex> OpenaiTTS.Config.start_link([])
      {:ok, pid}
  """
  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  @impl true
  def init(_opts) do
    config =
      @config_keys
      |> Enum.map(fn key -> {key, get_config_value(key)} end)
      |> Map.new()

    {:ok, config}
  end

  @doc """
  Retrieves the OpenAI API key.

  The key is fetched from the application environment or system environment.

  ## Returns
  - `String.t()` representing the API key.

  ## Example
      iex> OpenaiTTS.Config.api_key()
      "your-openai-api-key"
  """
  def api_key, do: get_config_value(:api_key)

  @doc """
  Retrieves the HTTP options for API requests.

  If not set, returns an empty list.

  ## Returns
  - `list()` of HTTP options.

  ## Example
      iex> OpenaiTTS.Config.http_options()
      []
  """
  def http_options, do: get_config_value(:http_options, [])

  @doc """
  Retrieves a configuration value from the GenServer state.

  ## Parameters
  - `key` (atom): The configuration key.

  ## Returns
  - The stored configuration value.

  ## Example
      iex> OpenaiTTS.Config.get(:api_key)
      "your-openai-api-key"
  """
  def get(key), do: GenServer.call(__MODULE__, {:get, key})

  @impl true
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl true
  def handle_call({:put, key, value}, _from, state) do
    {:reply, value, Map.put(state, key, value)}
  end

  defp get_config_value(key, default \\ nil) do
    value =
      :openai_tts
      |> Application.get_env(key)
      |> parse_config_value()

    if is_nil(value), do: default, else: value
  end

  defp parse_config_value({:system, env_name}), do: fetch_env!(env_name)

  defp parse_config_value({:system, :integer, env_name}) do
    env_name
    |> fetch_env!()
    |> String.to_integer()
  end

  defp parse_config_value(value), do: value

  @doc false
  defp fetch_env!(env_name) do
    case System.get_env(env_name) do
      nil ->
        raise ArgumentError,
          message: "failed to fetch environment variable \"#{env_name}\" - Not set"

      value -> value
    end
  end
end
