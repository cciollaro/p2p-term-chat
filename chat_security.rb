require 'openssl'

dir = "#{Dir.home}/.rube_chat"

unless File.exists?(dir) && File.directory?(dir)
	Dir.mkdir(dir)
end

Dir.chdir(dir)


if File.exists?('chat_key') && File.exists?('chat_key.pub')
	private_key = OpenSSL::PKey::RSA.new(File.open("#{Dir.home}/.rube_chat/chat_key"))
	public_key = OpenSSL::PKey::RSA.new(File.open("#{Dir.home}/.rube_chat/chat_key.pub"))
else
	key = OpenSSL::PKey::RSA.new 2048
	File.open('chat_key', 'w') {|file| file.write(key)}
	File.open('chat_key.pub', 'w') {|file| file.write(key.public_key)}
end
