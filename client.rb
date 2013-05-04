require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 8888

s = TCPSocket.open(hostname, port)


loop do
	inbound = s.gets
	puts line
end
