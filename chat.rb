# TODO - does not work in the same NAT :(. update middleman server to accept local ip as well, and pass it on.

require "readline"
require_relative "./direct_connection"

CLEAR_CUR_LINE = "\x1b[2K\x1b[0G"

direct_connection = DirectConnection.new(ARGV[0], ARGV[1].to_i, ARGV[2])

# listener thread
Thread.new do
  while in_msg = direct_connection.recv
    print CLEAR_CUR_LINE
    puts "<= #{in_msg}"
    print "=> #{Readline.line_buffer}"
  end
end

begin
  while out_msg = Readline::readline("=> ", true)
    direct_connection.send(out_msg)
  end
rescue Interrupt
  direct_connection.send("bye") rescue nil
ensure
  print CLEAR_CUR_LINE
  puts 'bye'
end
