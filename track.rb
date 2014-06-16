class Track
  attr_reader :id, :title, :album
  def initialize (metadatas)
    @id_track = metadatas[0]["mpris:trackid"]
    @title = metadatas[0]["xesam:title"]
    @album = metadatas[0]["xesam:album"]
  end

  def to_s
    if @title != nil
      "Chanson : " + @title + "\nAlbum : " + @album
    else
      "Pas de lecture"
    end
  end
end
