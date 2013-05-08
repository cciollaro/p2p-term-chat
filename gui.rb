#!/usr/bin/ruby

require 'gtk2'
require 'socket'
require 'thread'

class ChatClient < Gtk::Window
	attr_accessor :buff, :conn, :lock #references to the buffer of the textbox, and the connection to the server, mutex to write to buffer
    
    def initialize
        self.lock = Mutex.new
        super
        
        set_title "RubeChat"
        
        signal_connect "destroy" do 
            Gtk.main_quit 
        end
        
        init_ui
        
        set_default_size 500, 500
        set_window_position Gtk::Window::POS_CENTER
        
        show_all
    end
    
    def init_ui
        set_border_width 15
        
        table = Gtk::Table.new 4, 4
		
		scrolly = Gtk::ScrolledWindow.new # a scrolling wrapper for the textbox
		scrolly.set_policy(Gtk::POLICY_NEVER, Gtk::POLICY_AUTOMATIC) #no horizontal scroll, vertical scroll automatic  
		
		textbox = self.build_textbox #the textbox is the main display
		scrolly.add textbox
		
		table.attach scrolly, 0, 3, 0, 2
		
		entry = self.build_entry #an entry is a text input field
		table.attach entry, 0, 3, 2, 3
		
		self.add table
		
		entry.grab_focus #ensure entry has focus
		
		self.display_message "WELCOME"
    end
    
    def display_message(msg, prefix=nil)
		lock.synchronize do
			buff.insert buff.end_iter, "\n#{prefix}#{msg}"
		end
    end
     
    def build_entry
		entry = Gtk::Entry.new
		entry.signal_connect "activate" do
			display_message entry.buffer.text, "YOU: "
			self.conn.puts entry.buffer.text
			entry.buffer.text = ""
		end
		return entry
    end
    
    def build_textbox
		textbox = Gtk::TextView.new
		textbox.wrap_mode = Gtk::TextTag::WRAP_WORD_CHAR
        self.buff = textbox.buffer #now that textbox is made, save a reference to the buffer that it reads from
		return textbox 
    end
end

hostname = 'localhost'
port = 8888

s = TCPSocket.open(hostname, port)

Gtk.init  

window = ChatClient.new
window.conn = s

Thread.new do
	while msg = s.gets
		window.display_message(msg.chomp, "ANON: ")
	end
end

Gtk.main
