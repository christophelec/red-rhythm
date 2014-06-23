require 'dbus'
require_relative './henchman.rb'

class Rhythmbox
  def initialize
    @henchman = Henchman.instance
    bus = DBus::SessionBus.instance
    rb_service = bus.service("org.mpris.MediaPlayer2.rhythmbox")
    rb_player = rb_service.object("/org/mpris/MediaPlayer2")
    rb_player.introspect
    @rb_player_iface = rb_player["org.mpris.MediaPlayer2.Player"]
    @rb_properties = rb_player["org.freedesktop.DBus.Properties"]
  end

  def play
    @henchman.call_f(lambda{@rb_player_iface.Play})
  end

  def pause
    @henchman.call_f(lambda{@rb_player_iface.Pause})
  end

  def play_pause
    @henchman.call_f(lambda{@rb_player_iface.PlayPause})
  end
end
