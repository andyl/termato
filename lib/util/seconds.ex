defmodule Util.Seconds do

  @doc """
  Returns the current count in a string represenation.
  """
  def to_s(secs) do 
    asec = secs |> abs() 
    days = div(asec, 3600 * 24) |> pad()
    hors = rem(asec, 3600 * 24) |> div(3600) |> pad()
    mins = div(asec, 60) |> rem(60) |> pad()
    secs = rem(asec, 60) |> pad()
    xdays = if days == "00", do: nil, else: "#{days}d"
    xhors = if hors == "00", do: nil, else: "#{hors}h"
    [xdays, xhors, "#{mins}m", "#{secs}s"] |> Enum.join(" ") |> String.trim()
  end

  def signed_to_s(secs) when is_integer(secs) do
    sign = if secs < 0, do: "-", else: ""
    sign <> to_s(secs)
  end

  def signed_to_s(secs) do 
    secs |> String.to_integer() |> signed_to_s()
  end

  def klas(secs) do 
    cond do 
      secs < 0   -> "red"
      secs < 60  -> "magenta"
      secs < 300 -> "yellow"
      true       -> "green"
    end
  end

  defp pad(num) do 
    "#{num}" |> String.pad_leading(2, "0") 
  end

end
