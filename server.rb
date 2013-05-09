require 'socket'
require 'thread'

port = (ARGV.length.zero? ? 8888 : ARGV.first)

server = TCPServer.open(port)
connections = {} #shared between threads. is mapping from each active client to their listener thread
lock = Mutex.new

Thread.new do
	while msg = gets
		lock.synchronize do
			connections.each_key{|x| x.puts "SERVER: #{msg}"}
		end
	end
end

loop do
	new_client = server.accept
	
	t = Thread.new do
		while msg = new_client.gets
			lock.synchronize do
				connections.each_key do |x|
					next if x == new_client
					begin
						x.puts msg
					rescue Errno::EPIPE
						puts "a client disconnected"
						$stdout.flush
						th = connections.delete(x)
						Thread.kill(th)
						x.close
					end
				end
				puts connections.inspect
			end
		end
	end
	connections[new_client] = t
end
