# OpenaiTts

Simple Openai text to speech library

## Installation

The package can be installed
by adding `openai_tts` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:openai_tts, git: "https://github.com/liamkillingback/openai_tts"}
  ]
end
```

## Setup

In config.exs:

```elixir
  config :openai_tts
    api_key: "openai-api-key",
    http_options: [recv_timeout: :infinity]
```

## Usage

```elixir
@doc """
  Creates a voice file from text using OpenAI's TTS API.

  ## Parameters
  - `text` (string): The input text to convert to speech.
  - `voice` (string, optional): The voice model to use (default: `"onyx"`).
  - `speed` (float, optional): The speech speed (default: `1.0`).
  - `model` (string, optional): The TTS model to use (default: `"tts-1"`).
  - `format` (string, optional): The output file format (default: `"mp3"`).

  ## Returns
  - The response from `OpenaiTTS.TTS.create_voice/5`.

  ## Example
      iex> OpenaiTTS.create_voice("Hello world")
      {:ok, audio_binary}
  """


case OpenaiTTS.create_audio("Hello World") do
  {:ok, res} ->
    File.write!("/path/audio.mp3", res)
  {:error, message} ->
    # Handle error
    IO.inspect(message)
end

```

See [Openai TTS api docs](https://platform.openai.com/docs/api-reference/audio) for list of params & options.
