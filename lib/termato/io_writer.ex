defmodule Termato.IoWriter do

  @moduledoc """
  The IoWriter prints the Termato countdown prompt.

  IoWriter always starts with the Termato application.  It can be :enabled or
  :disabled as needed for development and testing.
  """

  use Agent

  alias Termato.{HttpSupervisor, Counter}

  @process_name __MODULE__
  @default_state :disabled

  # ----- STARTUP -----

  def start_link do 
    start_link([@default_state]) 
  end 

  def start_link([state]) when state in [:enabled, :disabled] do 
    Task.async(fn -> loop() end)
    Agent.start_link(fn -> state end, name: @process_name)
  end

  def start_link(_args) do 
    start_link([@default_state]) 
  end

  # ----- STATE -----

  def enable do 
    Agent.update(@process_name, fn _ -> :enabled end) 
  end

  def disable do 
    Agent.update(@process_name, fn _ -> :disabled end)
  end

  def state do 
    case Process.whereis(@process_name) do 
      nil -> :disabled
      _ -> Agent.get(@process_name, &(&1))
    end
  end

  def enabled? do 
    state() == :enabled
  end

  def disabled? do 
    state() == :disabled
  end

  # ----- LOOP ----- 

  defp loop do 

    if enabled?() do 
      if sound_alert?(), do: alert()
      print_output()
    end

    :timer.sleep(1000)

    loop() 

  end 

  # ----- HELPERS ----- 

  # this doesn't quite work...
  defp alert do 
    Task.async(fn -> System.cmd("play", ["ring", "&"]) ; Process.sleep(1000); end)
  end 

  defp sound_alert? do 
    Counter.expiring?() && HttpSupervisor.server_live?()
  end

  defp print_output do
    IO.write "\r                                                         "
    IO.write "\r#{prompt_text()}"
  end

  defp prompt_text do 
    secs = Counter.get_secs() 
    text = "TERMATO | #{Counter.to_s()} > "
    case Util.Seconds.klas(secs) do
      "red"     -> text |> Util.Color.red() 
      "magenta" -> text |> Util.Color.magenta()
      "yellow"  -> text |> Util.Color.yellow()
      true      -> text |> Util.Color.green()
    end
  end

end
