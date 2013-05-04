require 'socket'

server = TCPServer.open(8888)

client1 = server.accept
puts "one person connected"
client1.puts "waiting for partner"
client2 = server.accept
puts "both people connected"
client1.puts "connected to partner"
client2.puts "connected to partner"

Thread.new do
	while msg = client1.gets
		client2.puts msg
	end
end

Thread.new do
	while msg = client2.gets
		client1.puts msg
	end
end

loop {}
