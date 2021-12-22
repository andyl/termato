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

  use PlugSocket 
  use Plug.Router
  plug(:match)
  plug(:dispatch)

  socket "/sock", Termato.SockHandler

  def start do
    Plug.Cowboy.http(Termato.HttpServer, [], port: @http_port)
  end 

  def base_url do
    "http://localhost:#{@http_port}"
  end

  def raw_url do
    base_url() <> "/raw"
  end

  defp render(%{status: status} = conn, template, assigns) do
    body =
      case template do
        "live" -> Util.Template.live()
        "html" -> Util.Template.html() 
        _ -> raise("Bad template")
      end
      |> EEx.eval_string(assigns)

    send_resp(conn, (status || 200), body)
  end

  defp redirect(conn, url) do 
    body = "<html><body>Redirect to #{url}</body></html>"
    conn
    |> put_resp_header("location", url)
    |> send_resp(conn.status || 302, body)
  end

  defp redir_path(conn) do 
    case conn.query_string do 
      "" -> ""
      string -> Plug.Conn.Query.decode(string)["redirect"] || ""
    end
  end

  get "/" do
    history = Util.History.decode_recent_to_s(30) 
    render(conn, "live", history: history)
  end

  get "/raw" do 
    send_resp(conn, 200, Counter.get_secs())
  end

  get "/mins" do 
    send_resp(conn, 200, Counter.get_secs() / 60)
  end

  get "/secs" do 
    send_resp(conn, 200, Counter.get_secs())
  end

  get "/secs_to_s" do 
    send_resp(conn, 200, Counter.get_secs() |> Util.Seconds.to_s())
  end

  get "/history" do
    conn
    |> put_resp_header("Content-Type", "text/plain")
    |> send_resp(200, Util.History.recent_lines_to_s())
  end

  get "/html" do 
    render(conn, "html", [])
  end

  get "/live" do 
    history = Util.History.decode_recent_to_s(30) 
    render(conn, "live", history: history)
  end

  get "/set_secs/:secs" do
    Counter.set_secs(secs)
    case redir_path(conn) do
      "" -> send_resp(conn, 200, "OK")
      path -> redirect(conn, "/" <> path)
    end
  end

  get "/set_mins/:mins" do
    Counter.set_mins(mins)
    case redir_path(conn) do
      "" -> send_resp(conn, 200, "OK")
      path -> redirect(conn, "/" <> path)
    end
  end

  match _ do
    send_resp(conn, 404, "Unknown path")
  end
end
