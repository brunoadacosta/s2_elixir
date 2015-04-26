defmodule MyProcess do
  def hello(name), do: IO.puts "Hello #{name}"
end


pid = spawn fn -> MyProcess.hello "Async" end

IO.puts "#{inspect pid}"
