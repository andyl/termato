defmodule Termato.IoReader do

  @moduledoc """
  IoReader takes action based on keyboard input.

  IoReader always starts with the Termato application.  It can be :enabled or
  :disabled as needed for development and testing.
  """

  use Agent

  alias Termato.HttpClient

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

  def loop do 
    if enabled?() do
      data = Util.Kb.getch() 
      case data do
        "t" -> HttpClient.set_mins(25)
        "l" -> HttpClient.set_mins(15)
        "s" -> HttpClient.set_mins(5)
        "z" -> HttpClient.set_secs(5)
        "c" -> IO.write(IO.ANSI.clear()); IO.write(IO.ANSI.cursor(0,0))
        "?" -> print_help() 
        "x" -> IO.puts("\n---"); System.halt(0)
        _ -> print_msg("UNKNOWN ('?' for help)")
      end 
    else 
        Process.sleep(1000)
    end
    loop() 
  end 

  # ----- HELPERS ----- 

  defp print_msg(text) do 
    IO.puts(text)
  end

  defp print_help do 
    text = """

    termato options:
      - t : 25 mins (tomato task)
      - l : 15 mins (long break - after 4 tasks)
      - s :  5 mins (short break - between tasks)
      - z :  5 secs (test)
      - c : clear screen
      - h : history (last 20 events)
      - ? : help (this text)
      - x : terminate
    """
    IO.write(text)
  end

end
