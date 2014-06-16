# encoding: UTF-8
require 'curses'

class Music_view
  def initialize(n_rb_controller)
    @rb_controller = n_rb_controller
  end

  def get_track_string
    @track.title + " - " + @track.album + " par " + @track.artist
  end

  def get_playing_status
    case @rb_controller.get_playback_status
    when "Playing"
      "" << 0x25b6
    when "Paused"
      "" << 0x25a0
    when "Stopped"
      "Arret"
    else
      "Erreur"
    end
  end

  def volume
    ((@rb_controller.get_volume * 10).round.to_s).rjust(2, " ")
  end

  def show
    @track = @rb_controller.get_track
    if @rb_controller.is_stopped?
      to_show = "Pas de lecture"
    else
      to_show = get_track_string
      setpos(lines / 2, 0)
      addstr(get_playing_status)
      setpos(lines / 2, (cols - 2))
      addstr(volume)
    end
    to_show = to_show.center(cols - 4)
    setpos(lines / 2, 1)
    addstr(to_show)
    refresh
  end
end
