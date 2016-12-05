require File.expand_path '../spec_helper.rb', __FILE__

describe "My Sinatra Application" do
  it "returns 404 on root" do
    get '/'
    expect(last_response.status).to eq(404)
  end
end
