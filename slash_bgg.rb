require 'sinatra'
require 'httparty'
require 'dotenv'
require_relative 'bgg_api'
require_relative 'slack_response'

Dotenv.load
InvalidTokenError = Class.new(Exception)

class SlashBgg < Sinatra::Base
  post '/' do
    raise(InvalidTokenError) unless ENV['SLACK_TOKENS'].include?(params[:token])
    query_text = params.fetch('text').strip

    # check the query_text to see if its an int
    if query_text.to_i != 0
      # You entered an exact ID
      game =  BggThing.new(
        BggApi.get_thing(query_text)
      )

      slack_response = SlackResponse.game_response(game)
    elsif BggApi.search(query_text, exact: 1).result_count == 1
      # There is only 1 game result with that search term
      resp = BggApi.search(query_text, exact: 1)
      game = BggApi.get_thing(resp.thing_id)

      slack_response = SlackResponse.game_response(game)
    elsif BggApi.search(query_text, exact: 1).result_count > 0
      # there are several results, pick one
      results = BggApi.search(query_text, exact: 1)

      slack_response = SlackResponse.many_results(results)
    elsif BggApi.search(query_text).result_count > 0
      # Nothing found with that exact term, perhaps you meant...
      results = BggApi.search(query_text)

      slack_response = SlackResponse.suggestions(results)
    else
      # Not found.
      slack_response = SlackResponse.not_found
    end

    content_type :json
    slack_response
  end
end
