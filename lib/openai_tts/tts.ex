defmodule OpenaiTTS.TTS do
  @moduledoc """
  This module provides functionality for interacting with OpenAI's text-to-speech API.

  It allows you to generate speech from text using various parameters such as voice type, speed, model, and response format.
  """

  alias OpenaiTTS.Client

  @endpoint "/v1/audio/speech"

  @doc """
  Converts the provided text into speech using OpenAI's API.

  ## Parameters

    - `text` (String): The text you want to convert to speech.
    - `voice` (String): The type or identifier of the voice to use.
    - `speed` (Float): The speed of the speech output.
    - `model` (String): The AI model to use for speech generation.
    - `format` (String): The desired response format for the audio (e.g. alloy, ash, coral, echo, fable, onyx, nova, sage, shimmer).

  ## Example

      iex> OpenaiTTS.TTS.create_voice("Hello, world!", "en_us", 1.0, "text-to-speech-model", "mp3")
      {:ok, %{"audio_url" => "https://api.openai.com/audio/..."}}

  ## Returns

    - `{:ok, response}`: If the API request was successful, returns the response from the OpenAI API ( Which is file data ).
    - `{:error, reason}`: If the request failed, returns an error reason.
  """
  def create_voice(text, voice, speed, model, format) do
    case Client.post(@endpoint, %{
      model: model,
      response_format: format,
      input: text,
      voice: voice,
      speed: speed
    }) do
      {:ok, response} ->
        {:ok, response}
      {:error, reason} ->
        {:error, reason}
    end
  end
end
