defmodule Util.History do
  @history_file "~/.termato.csv"

  alias Util.Seconds, as: S

  def filename do 
    @history_file 
    |> Path.expand()
  end

  def text do 
    case File.exists?(filename()) do 
      true -> filename() |> File.read!()
      _ -> ""
    end
  end

  def stream do 
    filename()
    |> File.stream!
  end

  def decode_stream do 
    stream()
    |> CSV.decode!()
  end

  def decode_recent(num \\ 20) do 
    decode_stream()
    |> Enum.map(&(&1))
    |> Enum.reverse()
    |> Enum.take(num)
  end

  def decode_recent_to_s(num \\ 20) do 
    decode_recent(num) 
    |> Enum.map(fn([date, sec1, sec2]) -> [date, S.signed_to_s(sec1), S.signed_to_s(sec2)] end)
  end

  def recent_lines_to_s(num \\ 20) do 
    decode_recent_to_s(num)
    |> Enum.map(&(&1 |> Enum.join(",")))
    |> Enum.join("\n")
  end

  def recent_lines(num \\ 20) do
    text()
    |> String.split("\n")
    |> Enum.reverse()
    |> Enum.take(num) 
    |> Enum.join("\n")
    |> String.trim()
  end

  def write(text) do 
    filename()
    |> File.write(text <> "\n", [:append])
  end

  def over_write(text) do 
    filename()
    |> File.write(text <> "\n")
  end

end
