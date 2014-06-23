require_relative 'rhythmbox.rb'

class Key_mapper

  def initialize
    @logger = Logger.new("log_keys")
    @rb_controller = Rhythmbox.new
    @key_map = Hash.new
    @key_map['r'] = lambda {@rb_controller.shuffle_on_off}
    @key_map[0x1B] = method(:get_sequence)
    @key_map['q'] = lambda {exit}
    @key_map[' '] = lambda {@rb_controller.play_pause}
    @key_map['s'] = lambda {@rb_controller.show}
    @key_map['m'] = lambda {@rb_controller.mute_unmute}
  end

  def get_sequence
    case getch
    when '['
      case getch
      when 'A'
        ## UP
        @rb_controller.volume_up
      when 'B'
        ## DOWN
       @rb_controller.volume_down
      when 'C'
        ## RIGHT
        @rb_controller.next
      when 'D'
        ## LEFT
        @rb_controller.prev
      end
    end
  end

  def translate(character)
    res = @key_map[character]
    if res != nil
      @logger.info("detected key" + character.to_s + "\n")
      ret = res.call
      @logger.info("Got " + ret.to_s + "\n")
      ret
    end
  end
end
