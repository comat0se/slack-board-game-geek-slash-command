class SlackResponse
  def self.game_response(game)
    {
      "response_type": "in_channel",
      "attachments": [
          {
              "fallback": "#{game.name} thumbnail.",
              "title": "#{game.name}",
              "title_link": "https://boardgamegeek.com/boardgame/#{game.id}",
              "text": "#{game.description}",
              "thumb_url": "#{game.thumbnail}"
          }
      ]
    }.to_json
  end

  def self.many_results(results)
    dupe_string = results.items["item"].map {|result|
      "Type /bgg #{result["id"]} for #{result["name"]["value"]} published in #{result["yearpublished"]["value"]}"
    }.join(", ")

    {
      "response_type": "in_channel",
      "text": "There are more than 1 games by that name. #{dupe_string}"
    }.to_json
  end

  def self.suggestions(results)
    non_exact_string = results.items["item"].map{|item| item["name"]["value"]}.join(", ")

    {
      "response_type": "in_channel",
      "text": "There are no results. Maybe you meant one of these: #{non_exact_string}."
    }.to_json
  end

  def self.not_found
    {
      "response_type": "in_channel",
      "text": "Somehow there are no results. Time to find a new game!"
    }.to_json
  end
end
