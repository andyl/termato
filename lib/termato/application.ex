defmodule Termato.Application do
  @moduledoc false

  use Application

  def init do
    # required by HTTPoison...
    Termato.HttpClient.start()
  end

  @impl true
  def start(_type, _args) do

    init()

    children = [
      # HttpSupervisor is dynamic - allows HttpServer to be turned on and off as needed
      {Termato.HttpSupervisor, []}, 
      {Termato.Counter, []}, 
      {Termato.Zookeeper, []}, 
      # sometimes it's handy to disable IoReader and IoWriter for testing...
      {Termato.IoReader, [:enabled]}, 
      {Termato.IoWriter, [:enabled]}, 
    ]

    opts = [strategy: :one_for_one, name: Termato.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start do
    start(:ok, :ok)
  end

  # you can call this from an Elixir script - see example in README.md
  def start_run do
    start(:ok, :ok)
    Process.sleep(:infinity)
  end
end
