defmodule Geladeira do
  require Logger

  def start(list) do
    pid = spawn(__MODULE__, :loop, [list])
    Process.register pid, :geladeira
  end

  def stop do
    send(:geladeira, :stop)
  end

  def add(food) do
    send(:geladeira, {self, :add, food})
    receive do
      {_pid, message} -> 
        IO.puts message
      after 
        1500 -> Logger.info "Unexpected message"
    end
  end

  def get(food) do
    send(:geladeira, {self, :get, food})
    receive do
      {_pid, message} -> 
        IO.puts message
      after 
        1500 -> Logger.info "Unexpected message"
    end
  end

  def loop(list) do
    receive do 
      :stop -> 
        Logger.info "Geladeira is finalized"
        :ok
      {from, :add, food} -> 
        if Enum.member?(list, food) do
          send from, {self, "Already exists"}
          loop(list)
        else
          send from, {self, "#{inspect food} has been added"}
          loop([food | list])
        end
      {from, :get, food} -> 
        if Enum.member?(list, food) do
          send from, {self, "Get #{inspect food}"}
          loop(List.delete(list, food))
        else
          send from, {self, "This food does not exists"}
          loop(list)
        end
      _ -> 
        Logger.info "Mensagem não esperada" 
    end
  end
end
