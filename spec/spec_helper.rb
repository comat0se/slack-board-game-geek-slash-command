# spec/spec_helper.rb
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../slash_bgg.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() SlashBgg end
end

RSpec.configure { |c| c.include RSpecMixin }