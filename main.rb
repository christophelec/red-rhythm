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
timeout=1000

sync = Mutex.new

controller_thread = Thread.new do
  sync.lock
  loop do
    k.translate(getch)
    sync.unlock
    logger.info("Mutex unlocked")
    sync.lock
  end
end


loop do
  v.show
  sync.lock
  sync.unlock
end
