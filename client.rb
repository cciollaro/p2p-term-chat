require 'socket'

hostname = 'localhost'
port = 8888

s = TCPSocket.open(hostname, port)


Thread.new do
	while msg = s.gets
		puts msg
	end
end


loop do
	s.puts gets
end
