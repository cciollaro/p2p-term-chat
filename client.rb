require 'socket'
require 'readline'

hostname = 'localhost'
port = 8888

s = TCPSocket.open(hostname, port)

include Readline
CLEAR_CUR_LINE = "\x1b[2K\x1b[0G"

name = "YOU"

Thread.new do
	while msg = s.gets
        print CLEAR_CUR_LINE
        puts "ANON: " + msg
        print name + ": " + Readline.line_buffer
	end
end


loop do
	s.puts readline(name + ": ", true)
end
