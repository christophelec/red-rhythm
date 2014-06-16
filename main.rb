require_relative './key_mapper.rb'
require_relative './rhythmbox_model.rb'
require_relative './music_view.rb'
require "curses"
include Curses
include Signal

rb_controller = Rhythmbox_model.new
k = Key_mapper.new(rb_controller)
v = Music_view.new(rb_controller)
init_screen
logger = Logger.new('log')
clear_asked = false
sync = Mutex.new

#Signal handling
Signal.trap("SIGWINCH") do
  clear_asked = true
end

# Makes cursor invisible
curs_set(0)
nl

# Characters typed are not printed
noecho

# Empties the screen
clear
refresh

# Characters typed are sent immediatly to the program, instead of waiting for
# a carriage return
cbreak

view_thread = Thread.new do
  loop do
    v.show
    if clear_asked
      clear
      clear_asked = false
    end
    Thread.stop
  end
end

ping_thread = Thread.new do
  loop do
    sleep(1)
    view_thread.wakeup
  end
end

loop do
  k.translate(getch)
  view_thread.wakeup
end
