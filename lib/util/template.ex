defmodule Util.Template do
  def html do
    unquote do
      File.read!("lib/termato/templates/html.html.eex")
    end
    |> Keyword.get(:do)
  end

  def live do
    unquote do
      File.read!("lib/termato/templates/live.html.eex")
    end
    |> Keyword.get(:do)
  end
end
