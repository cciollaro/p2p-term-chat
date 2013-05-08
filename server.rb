require 'socket'
require 'thread'

port = (ARGV.length.zero? ? 8888 : ARGV.first)

server = TCPServer.open(port)
clients = []
lock = Mutex.new

Thread.new do
	while msg = gets
		lock.synchronize do
			clients.each{|x| x.puts "SERVER: #{msg}"}
		end
	end
end

loop do
	new_client = server.accept
	clients << new_client
	Thread.new(new_client) do |chatter|
		while msg = chatter.gets
			lock.synchronize do
				clients.reject{|x| x == chatter}.each{|x| x.puts msg}
			end
		end
	end
end
