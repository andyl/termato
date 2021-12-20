defmodule Termato.Zookeeper do

  @moduledoc """
  The Zookeeper coordinates the activities of the Counter and HttpServer.

  If the current Termato instance is the leader (bc it's running an
  HttpServer), the Counter will be decremented, and the HttpServer will serve
  time for all followers.

  Otherwise, if a live HttpServer is found on localhost, it will be used to
  pull the time signal.

  Otherwise, it will try to start an HttpServer and become the leader.
  """

  use Task 

  alias Termato.{HttpSupervisor, Counter, HttpClient}
  alias Termato.SockHandler

  # ----- API -----

  def leader? do 
    HttpSupervisor.server_live?()
  end

  # ----- STARTUP ----- 

  def start_link(_) do 
    Task.start_link(fn -> loop() end)
  end

  # ----- LOOP ----- 

  defp loop do 
    if HttpSupervisor.server_live?() do 
      Counter.decrement()
      SockHandler.broadcast("TICK", Counter.get_secs())
    else 
      case HttpClient.get_secs() do 
        :server_not_found -> HttpSupervisor.start_server()
        secs -> Counter.set_secs(secs)
      end
    end

    if Counter.get_secs() == 0 do
      case System.fetch_env("TERMATO_ALERT") do
        {:ok, cmd} -> Task.async(fn -> System.cmd(cmd, []) end)
        _ -> :ok 
      end
    end

    Process.sleep(1000)

    loop() 
  end 

end
