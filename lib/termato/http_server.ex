defmodule Termato.HttpServer do

  @moduledoc """
  The HttpServer allows all the Termato processes on a machine to keep the same
  time.

  Only one HttpServer will run on a given machine.  

  The HttpServer listens on port 5555.  

  Test using `curl http://localhost:5555`
  """

  @http_port 5555 

  alias Termato.Counter

  use Plug.Router
  plug(:match)
  plug(:dispatch)

  def start do
    Plug.Cowboy.http(Termato.HttpServer, [], port: @http_port)
  end 

  def base_url do
    "http://localhost:#{@http_port}"
  end

  get "/" do
    secs = Counter.get_secs()
    send_resp(conn, 200, "#{secs}")
  end

  get "/set_secs/:secs" do
    Counter.set_secs(secs)
    send_resp(conn, 200, "OK")
  end

  get "/set_mins/:mins" do
    Counter.set_mins(mins)
    send_resp(conn, 200, "OK")
  end

  match _ do
    send_resp(conn, 404, "Unknown path")
  end
end
