require "socket"
require "ipaddr"

class DirectConnection
  attr_accessor :udp_socket, :partner_ip, :partner_port

  def initialize(middleman_host, middleman_port, topic)
    self.udp_socket = UDPSocket.new
    self.udp_socket.send(topic, 0, middleman_host, middleman_port)
    blocking_recv(self.udp_socket, topic.length + 3)
    self.udp_socket.send("ok", 0, middleman_host, middleman_port)

    data, addr = blocking_recv(self.udp_socket, 6)
    self.partner_ip = ip_from_bytes(data)
    self.partner_port = port_from_bytes(data)

    p "your partner is: #{self.partner_ip} #{self.partner_port}"

    # how about some redundancy
    self.udp_socket.send("meta:greetings", 0, self.partner_ip, self.partner_port)
    self.udp_socket.send("meta:greetings", 0, self.partner_ip, self.partner_port)
    self.udp_socket.send("meta:greetings", 0, self.partner_ip, self.partner_port)
    self.udp_socket.send("meta:greetings", 0, self.partner_ip, self.partner_port)
    self.udp_socket.send("meta:greetings", 0, self.partner_ip, self.partner_port)
    self.udp_socket.send("meta:greetings", 0, self.partner_ip, self.partner_port)
  end

  def send(msg)
    self.udp_socket.send(msg, 0, self.partner_ip, self.partner_port)
  end

  def recv
    while msg = blocking_recv(self.udp_socket, 1024).first
      next if msg == "meta:greetings"
      break
    end
    msg
  end

  private

  def ip_from_bytes(b)
    IPAddr.ntop(b[0...-2])
  end

  def port_from_bytes(b)
    b[-2..-1].unpack("S").first
  end

  def blocking_recv(sock, len)
    begin # emulate blocking recvfrom
      sock.recvfrom_nonblock(len)
    rescue IO::WaitReadable
      IO.select([sock])
      retry
    end
  end
end
