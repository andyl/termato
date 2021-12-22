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
    case HtClient.get(raw_url()) do
      {:ok, response} -> response.body |> raw_get()
      _ -> :server_not_found
    end
  end

  def raw_get(""), do: 1500 
  def raw_get(body), do: body |> Integer.parse() |> elem(0)

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
  defdelegate raw_url , to: Termato.HttpServer

end
