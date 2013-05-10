require 'openssl'

class ChatSecurity
	attr_accessor :private_key, :public_key, :partner_public_key
	
	def initialize(partner_pub)
		@partner_public_key = partner_pub
		
		dir = "#{Dir.home}/.rube_chat"

		unless File.exists?(dir) && File.directory?(dir)
			Dir.mkdir(dir)
		end

		Dir.chdir(dir)


		if File.exists?('chat_key') && File.exists?('chat_key.pub')
			@private_key = OpenSSL::PKey::RSA.new(File.open("#{Dir.home}/.rube_chat/chat_key"))
			@public_key = OpenSSL::PKey::RSA.new(File.open("#{Dir.home}/.rube_chat/chat_key.pub"))
		else
			@private_key = OpenSSL::PKey::RSA.new(2048)
			@public_key = private_key.public_key
			File.open('chat_key', 'w') {|file| file.write(@private_key)}
			File.open('chat_key.pub', 'w') {|file| file.write(@public_key)}
		end
	end
	
	def encrypt_message(msg)
		out_message = @partner_public_key.public_encrypt(msg)
		out_message = @private_key.private_encrypt(out_message)
		return out_message
	end
	
	def decrypt_message(msg)
		in_message = @partner_public_key.public_decrypt(msg)
		in_message = @private_key.private_decrypt(in_message)
		return in_message
	end
end
