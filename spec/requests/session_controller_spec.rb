require "rails_helper"

describe SessionsController do
	it "should get new" do
  	get '/'	
  	expect(response.status).to eql 200
  end
end