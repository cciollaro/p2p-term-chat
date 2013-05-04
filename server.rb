require 'socket'

server = TCPServer.open(8888)
clients = []

def broadcast(chatters)
	Thread.new do
		while msg = chatters[-1].gets
			chatters[0..-2].each{|x| x.puts msg}
		end
	end
end

loop do
	clients << server.accept
	puts "someone joined"
	clients[-1].puts "#{clients.size} people present"
	broadcast(clients)
end
