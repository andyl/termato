defmodule Termato.SockClient do
  use WebSockex

  def start_link do
    start_link(:ok, []) 
  end

  def start_link(_url, state) do
    WebSockex.start_link("ws://localhost:5555/sock", __MODULE__, state)
  end

  def send(message) do 
    WebSockex.send_frame(__MODULE__, {:text, message})
  end

  def send(pid, message) do 
    WebSockex.send_frame(pid, {:text, message})
  end

  def handle_frame({type, msg}, state) do
    IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    {:ok, state}
  end

  def handle_frame(data, state) do 
    IO.puts "Received Data Frame: #{data}"
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end

  def handle_cast(data, state) do 
    IO.puts "Received Frame Cast: #{data}"
    {:reply, data, state}
  end

  def handle_call(data, state) do
    IO.puts "++++++++++++++++++++++++++"
    IO.inspect data, label: data
    IO.inspect state, label: state
    IO.puts "++++++++++++++++++++++++++"
    {:reply, data, state}
  end
end
