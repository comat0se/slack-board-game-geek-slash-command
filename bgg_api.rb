class BggApi
  def self.search(query_text, exact: nil)
    HTTParty.get(
      'http://www.boardgamegeek.com/xmlapi2/search',
      query: {
        query: query_text,
        :type => 'boardgame',
        :exact => exact
      }
    )
  end

  def self.get_thing(id)
    HTTParty.get("http://www.boardgamegeek.com/xmlapi2/thing",
      query: {:id => id}
    )
  end
end

class BggThing
  attr_accessor :id, :response, :name, :game, :thumbnail, :description, :link

  def initialize(response)
    self.response = response
    self.id = id
    self.name = name
    self.thumbnail = thumbnail
    self.description = description
    self.link = link
  end

  def name
    if game["name"].is_a?(Array)
      game["name"].find {|name| name["type"] == "primary"}["value"]
    elsif game["name"].is_a?(Hash)
      game["name"]["value"]
    end
  end

  def thumbnail
    url = game["thumbnail"]
    "https:" + url
  end

  def description
    game["description"]
  end

  def link
    "https://www.boardgamegeek.com/boardgame/#{id}"
  end

  def id
    game["id"].to_i
  end

  private

  def game
    response["items"]["item"]
  end
end

class BggResponse
  attr_accessor :result_count, :response, :ids, :items

  def initialize(response)
    self.response = response
    self.result_count = result_count
  end

  def result_count
    items["total"].to_i
  end

  def thing_id
    items["item"]["id"].to_i
  end

  def items
    response["items"]
  end
end
