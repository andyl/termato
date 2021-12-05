defmodule Util.Kb do 

  @moduledoc """
  Utility functions.
  """

  @doc """
  It was a challenge to find a single-keypress `getch` solution for Elixir.  

  I tried: ex_ncurses, System.cmd, Rambo, Rustler, bash/read, and a few others.

  The approach here works on linux, but only if you have a ruby environment
  installed, with the erlang-etf gem.

  Not so portable...

  If anyone can tell me how to implement a portable `getch` for Elixir, I sure
  would appreciate it!
  """
  def getch(prompt \\ "")  do
    IO.write(prompt)
    port = Port.open({:spawn, ruby_cmd()}, [:binary, {:packet, 4}, :nouse_stdio])
    receive do
      {^port, {:data, result}} -> char_for(result)
    end
  end

  defp char_for(result) do 
    {:response, char} = :erlang.binary_to_term(result) 
    char
  end

  defp ruby_cmd do 
    ~S"""
    ruby -e '
    require "bundler"
    require "erlang/etf"
    require "io/console"

    @input = IO.new(3)
    @output = IO.new(4)
    @output.sync = true

    val = STDIN.getch

    def send_response(value)
      response = Erlang.term_to_binary(Erlang::Tuple[:response, value])
      @output.write([response.length].pack("N"))
      @output.write(response)
      true
    end

    send_response(val)
    '
    """
  end

end
