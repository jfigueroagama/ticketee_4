require 'spec_helper'

describe "Api errors", :type => :api do
  it "making a request with no token" do
    # get will pass a empty string as tokeb
    get "/api/v1/projects.json", :token => ""
    error = { :error => "Token is invalid."}
    response.body.should eql(error.to_json)
  end
end
