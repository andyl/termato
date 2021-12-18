defmodule Termato.HttpSupervisor do

  @moduledoc """
  Dynamically starts and stops the HttpServer.
  """

  use DynamicSupervisor 

  # ----- API -----

  def start_server do
    data = [port: 5555, dispatch: PlugSocket.plug_cowboy_dispatch(Termato.HttpServer)]
    opts = [ scheme: :http, plug: Termato.HttpServer, options: data ] 
    spec = { Plug.Cowboy, opts }

    IO.puts("Starting Termato server on port 5555")

    case server_pid() do
      :no_server -> DynamicSupervisor.start_child(__MODULE__, spec)
      pid -> {:ok, pid}
    end
  end

  def stop_server do 
    case server_pid() do 
      :no_server -> :ok 
      pid -> DynamicSupervisor.terminate_child(__MODULE__, pid)
    end
  end

  def server_live? do
    server_pid() != :no_server
  end

  def server_dead? do
    server_pid() == :no_server
  end

  # ----- Callbacks -----

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(_args) do 
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # ----- Private -----

  defp server_pid do 
    case Supervisor.which_children(__MODULE__) do 
      [{_, pid, _, _}] -> pid 
      _ -> :no_server
    end
  end

end
