defmodule PingPong do
  require Logger

  def start do
    spawn fn -> 
      receive do
        {from, :ping} -> 
        send from, {self, "Pong from: #{inspect self} to: #{inspect from}"}
        _ ->
          Logger.debug fn -> "Ignorando mensagem" end
      end
    end
  end

  def ping(pid) when is_pid(pid) do
    send pid, {self, :pinga}
    receive do 
      {^pid, message} -> 
        IO.puts message
     after
      500 -> Logger.info "Mórreu..."
    end
  end
end
