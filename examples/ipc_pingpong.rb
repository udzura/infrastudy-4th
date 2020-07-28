mode = ARGV[0]

case mode
when "ping"
  ping = PMQ.create('/ping001', mode: "w")
  pong = PMQ.create('/pong001', mode: "r")
  puts "Send ping: #{Time.now.to_f}"
  ping.send("ping!")
  ret = pong.receive
  puts "Received #{ret}: #{Time.now.to_f}"
  exit
when "pong"
  ping = PMQ.create('/ping001', mode: "r")
  pong = PMQ.create('/pong001', mode: "w")
  puts "Waiting for ping..."
  loop do
    ret = ping.receive
    puts "Received #{ret}: #{Time.now.to_f}"
    puts "Send pong: #{Time.now.to_f}"
    pong.send("pong!")
  end
else
  puts "Usage: #{$0} [ping|pong]"
end
