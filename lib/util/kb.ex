defmodule Util.Kb do 

  @moduledoc """
  Utility functions.
  """

  @doc """
  It was a challenge to find a single-keypress `getch` solution for Elixir.  

  I tried: ex_ncurses, System.cmd, Rambo, Rustler, bash/read, and a few others.

  The approach here works on linux, but only if you have a ruby environment
  installed.

  Not so portable...

  If anyone can tell me how to write a portable `getch` for Elixir, I sure
  would appreciate it!


  """
  def getch(prompt \\ "")  do
    IO.write(prompt)
    port = Port.open({:spawn, ruby_cmd()}, [:binary, :nouse_stdio])
    receive do
      {^port, {:data, result}} -> result
    end
  end

  defp ruby_cmd do 
    ~S"""
    ruby -e '
    require "io/console"

    @output = IO.new(4)
    @output.sync = true

    char = STDIN.getch

    @output.write(char) 
    '
    """
  end

end
