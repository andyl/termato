defmodule Termato.SockHandler do
  @behaviour :cowboy_websocket

  # ----- Setup & Teardown Callbacks ----- 
  
  def init(req, state) do 
    {:cowboy_websocket, req, state}
  end

  def websocket_init(state) do 
    IO.inspect self(), label: "WEBSOCKET INIT"
    Process.sleep(250)
    Termato.SockPidstore.add_client(self())
    {:ok, state}
  end

  def terminate(reason, _req, state) do 
    IO.inspect([self(), reason], label: "WEBSOCKET TERMINATE")
    Termato.SockPidstore.rm_client(self())
    {:ok, state} 
  end

  # ----- API -----
  def broadcast(msg_type) do 
    ~s({"type": "#{msg_type}"})
    |> send_all()
  end

  def broadcast(type, secs) when is_integer(secs) do 
    text = Util.Seconds.to_s(secs)
    klas = Util.Seconds.klas(secs)
    ~s({"type": "#{type}", "secs": #{secs}, "text": "#{text}", "klas": "#{klas}"})
    |> send_all()
  end

  def broadcast(msg_type, msg_value) do 
    ~s({"type": "#{msg_type}", "value": "#{msg_value}"})
    |> send_all()
  end

  defp send_all(message) do 
    Termato.SockPidstore.clients() 
    |> Enum.each(&(send_one(&1, message)))
  end

  defp send_one(pid, message) do 
    send(pid, message)
  end

  # ----- Event Callbacks -----

  def websocket_info({:timeout, _ref, message}, state) do 
    IO.inspect message, label: "TIMEOUT"
    {[{:text, message}], state} 
  end

  def websocket_info(data, state) do 
    # IO.inspect data, label: "INFODATA"
    {[{:text, data}], state} 
  end

  def websocket_handle({:text, message = "HEARTBEAT"}, state) do 
    # IO.inspect self(), label: "HEARTBEAT"
    {[{:text, message}], state} 
  end

  def websocket_handle({:text, message}, state) do 
    # IO.inspect message, label: "MESSAGE"
    {[{:text, message}], state} 
  end

  def websocket_handle(data, state) do 
    IO.inspect data, label: "GENERIC HANDLER"
    {[{:text, data}], state} 
  end

end
