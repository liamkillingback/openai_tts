defmodule OpenaiTTS do
  @moduledoc """
  The `OpenaiTTS` module serves as the main application entry point
  and provides a delegate function for generating speech from text
  using OpenAI's Text-to-Speech (TTS) API.
  """

  use Application

  alias OpenaiTTS.Config

  @doc """
  Starts the `OpenaiTTS` application.

  ## Parameters
  - `_type`: The type of startup (not used).
  - `_args`: The arguments passed to the application (not used).

  ## Returns
  - A tuple `{:ok, pid}` on success.

  ## Example
      iex> OpenaiTTS.start(:normal, [])
      {:ok, pid}
  """
  def start(_type, _args) do
    children = [Config]
    opts = [strategy: :one_for_one, name: OpenaiTTS.Supervisor]

    Supervisor.start_link(children, opts)
  end

  @doc """
  Creates a voice file from text using OpenAI's TTS API.

  This function delegates to `OpenaiTTS.TTS.create_voice/5`.

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
  defdelegate create_voice(text, voice \\ "onyx", speed \\ 1.0, model \\ "tts-1", format \\ "mp3"),
    to: OpenaiTTS.TTS
end

