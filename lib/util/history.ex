defmodule Util.History do
  @history_file "~/.termato.csv"

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
