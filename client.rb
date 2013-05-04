require 'socket'

hostname = 'localhost'
port = 8888

s = TCPSocket.open(hostname, port)


Thread.new do
	loop do
		puts s.gets
	end
end


loop do
	s.puts gets
end
