defmodule Termato.Counter do

  @moduledoc """
  The Counter tracks time for each tomato process.

  The internal state is just a single integer: seconds.
  """

  use Agent

  @process_name __MODULE__
  @default_mins 25

  # ----- STARTUP -----

  def start_link do 
    start_link(@default_mins) 
  end 

  def start_link(mins) when is_integer(mins) do 
    Agent.start_link(fn -> mins * 60 end, name: @process_name)
  end

  def start_link(_args) do 
    start_link(@default_mins) 
  end

  # ----- API ----- 
  
  @doc """
  Returns the current state - seconds - an integer.
  """
  @spec get_secs :: integer()
  def get_secs do
    Agent.get(@process_name, &(&1))
  end

  @doc """
  Decrements the current state by one second.
  """
  @spec decrement() :: :ok 
  def decrement do
    Agent.update(@process_name, &(&1 - 1))
  end

  @doc """
  Updates the counter state with a new second count.
  """
  @spec set_secs(String.t) :: :ok 
  def set_secs(new_secs) when is_binary(new_secs) do
    new_secs
    |> Integer.parse()
    |> elem(0)
    |> set_secs()
  end

  @spec set_secs(integer()) :: :ok 
  def set_secs(new_secs) do
    update_history(new_secs)
    Agent.update(@process_name, fn(_) -> new_secs end)
  end

  @doc """
  Updates the counter state with a new second count.

  Takes value in minutes and converts to seconds before storing.
  """
  @spec set_secs(String.t()) :: :ok 
  def set_mins(new_mins) when is_binary(new_mins) do
    new_mins
    |> Integer.parse()
    |> elem(0)
    |> set_mins()
  end

  @spec set_secs(integer) :: :ok 
  def set_mins(new_mins) do
    new_mins * 60
    |> set_secs()
  end

  @doc """
  True when seconds == 0.
  """
  @spec expiring?() :: boolean()
  def expiring? do 
    get_secs() == 0
  end

  @doc """
  Returns the current count in a string represenation.
  """
  @spec to_s() :: String.t()
  def to_s do 
    get_secs() |> Util.Seconds.to_s()
  end

  defp update_history(secs) do
    old_secs = get_secs() 
    date = Util.Time.now()

    "#{date},#{old_secs},#{secs}" |> Util.History.write()
  end

end
