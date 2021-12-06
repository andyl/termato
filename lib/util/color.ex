defmodule Util.Color do

  alias IO.ANSI, as: C

  def green(txt) do 
    C.green() <> txt <> C.reset()
  end

  def yellow(txt) do 
    C.yellow() <> txt <> C.reset()
  end

  def magenta(txt) do 
    C.magenta() <> txt <> C.reset()
  end

  def red(txt) do 
    C.red() <> txt <> C.reset()
  end

  def blue(txt) do 
    C.blue() <> txt <> C.reset()
  end

  def underline(txt) do 
    C.underline() <> txt <> C.reset()
  end

end
