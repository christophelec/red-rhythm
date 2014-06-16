require_relative 'track.rb'
require 'dbus'

class Rhythmbox_model
  def initialize
    bus = DBus::SessionBus.instance
    rb_service = bus.service("org.mpris.MediaPlayer2.rhythmbox")
    rb_player = rb_service.object("/org/mpris/MediaPlayer2")
    rb_player.introspect
    @rb_player_iface = rb_player["org.mpris.MediaPlayer2.Player"]
    @rb_properties = rb_player["org.freedesktop.DBus.Properties"]
  end

  def next
    begin
      @rb_player_iface.Next
    rescue
    end
  end

  def prev
    begin
      @rb_player_iface.Previous
    rescue
    end
  end

  def get_volume
    @rb_properties.Get("org.mpris.MediaPlayer2.Player", "Volume")[0]
  end

  def volume_up
    @rb_properties.Set("org.mpris.MediaPlayer2.Player", "Volume", get_volume + 0.1)
  end

  def volume_down
    @rb_properties.Set("org.mpris.MediaPlayer2.Player", "Volume", get_volume - 0.1)
  end

  def mute_unmute
    volume = get_volume
    if volume == 0.0
      if @prev_volume != 0.0
        volume = @prev_volume
      else
        volume = 1.0
      end
    else
      @prev_volume = volume
      volume = 0.0
    end
    @rb_properties.Set("org.mpris.MediaPlayer2.Player", "Volume", volume)
  end

  def get_playback_status
    @rb_properties.Get("org.mpris.MediaPlayer2.Player", "PlaybackStatus")[0]
  end

  def is_stopped?
    @rb_properties.Get("org.mpris.MediaPlayer2.Player", "PlaybackStatus")[0] == "Stopped"
  end

  def show
    playing = Track.new(@rb_properties.Get("org.mpris.MediaPlayer2.Player", "Metadata"))
    puts playing.title
  end

  def get_track
    Track.new(@rb_properties.Get("org.mpris.MediaPlayer2.Player", "Metadata"))
  end

  def start
    @rb_player_iface.Play
  end

  def stop
    @rb_player_iface.Stop
  end

  def pause
    @rb_player_iface.Pause
  end

  def play_pause
    @rb_player_iface.PlayPause
  end
end
