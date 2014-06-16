require_relative 'rhythmbox_model.rb'

class Key_mapper

  def initialize(n_rb_controller)
    @rb_controller = n_rb_controller
    @key_map = Hash.new
    @key_map['r'] = method(:shuffle)
    @key_map[0x1B] = method(:get_sequence)
    @key_map['q'] = lambda {exit}
    @key_map[' '] = lambda {@rb_controller.play_pause}
    @key_map['s'] = lambda {@rb_controller.show}
    @key_map['m'] = lambda {@rb_controller.mute_unmute}
  end

  def shuffle
    puts "Shuffling"
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
      res.call
    end
  end
end
