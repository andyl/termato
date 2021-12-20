defmodule Termato.SockPidstore do

  @moduledoc """
  Keeps track of website client pids.
  """

  use Agent

  @process_name __MODULE__

  # ----- STARTUP -----

  def start_link do 
    Agent.start_link(fn -> [] end, name: @process_name)
  end

  def start_link(_) do 
    start_link()
  end

  # ----- API -----
  
  def clients do 
    Agent.get(@process_name, &(&1))
  end

  def add_client(pid) do
    Agent.get_and_update(@process_name, fn(list) -> 
      new_list = list |> Enum.concat([pid])
      {list, new_list}
    end)
  end

  def rm_client(pid) do
    new_pids = clients() |> Enum.filter(&(&1 != pid)) 
    Agent.update(@process_name, fn(_) -> new_pids end)
  end

end
