require "json"

class DataManager
  def initialize(items)
    @items = items
  end

  def save_data(items)
    items_data = serialize_data(items)
    File.write("./lib/records/items.json", JSON.generate(items_data))
  end

  def load_data
    items_data = File.exist?("./lib/records/items.json") ? JSON.parse(File.read("./lib/records/items.json")) : []
    deserialize_data(items_data)
  end

  def serialize_data(items)
    items.map do |item|
      if item.instance_of?(MusicAlbum)
        {
          type: "MusicAlbum",
          id: item.id,
          genre_name: item.genre.name,
          publish_date: item.publish_date,
          on_spotify: item.on_spotify,
        }
      elsif item.instance_of?(Game)
        {
          type: "Game",
          id: item.id,
          multiplayer: item.multiplayer,
          last_played_at: item.last_played_at,
          publish_date: item.publish_date,
          author: "#{item.author.first_name} #{item.author.last_name}",
        }
      else
        next
      end
    end
  end

  def deserialize_data(items_data)
    items = []
    items_data.each do |item_data|
      next unless item_data["type"] == "MusicAlbum"

      genre_name = item_data["genre_name"]
      publish_date = item_data["publish_date"].to_i
      on_spotify = item_data["on_spotify"]

      genre = Genre.new(genre_name)
      music_album = MusicAlbum.new(genre, publish_date, on_spotify)
      items << music_album
    end
    items
  end
end
