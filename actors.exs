pid = spawn fn -> 
  receive do
    { from, message } -> 
      send from, { self, "Hello #{message}" }
  end
end

send pid, { self, "me, myself and I!" }

receive do 
 { ^pid, message } -> 
  IO.puts message
end
