require_relative './key_mapper.rb'
require 'curses'

Curses.init_screen

logger = Logger.new("log_main")

hench_thread = Thread.new do
  logger.info "Henchman running !"
  Henchman.instance.run
  logger.fatal "Henchman down !"
end

@key_mapper = Key_mapper.new
logger.info "key_mapper running !"
loop do
  @key_mapper.translate(Curses.getch)
end
logger.info "key_mapper down !"
