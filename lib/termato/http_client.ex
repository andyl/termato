defmodule Termato.HttpClient do

  @moduledoc """
  The Client reads and writes data from the Http Server.

  This module is just a wrapper around HTTPoison.
  """

  alias HTTPoison, as: HtClient

  def start do 
    HtClient.start()
  end

  def server_down? do
    case get_secs() do 
      {:error, _} -> true
      _ -> false
    end
  end

  def server_up? do 
    ! server_down?() 
  end

  def get_secs do 
    case HtClient.get(base_url()) do
      {:ok, response} -> response.body |> Integer.parse() |> elem(0)
      _ -> :server_not_found
    end
  end

  def set_secs(secs) do 
    path = base_url() <> "/set_secs/#{secs}"
    case HtClient.get(path) do
      {:ok, response} -> response.body 
      _ -> :server_not_found
    end
  end

  def set_mins(mins) do 
    path = base_url() <> "/set_mins/#{mins}"
    case HtClient.get(path) do 
      {:ok, response} -> response.body 
      _ -> :server_not_found
    end
  end

  defdelegate base_url, to: Termato.HttpServer

end
