 require 'rails_helper'

 describe StaticPagesController do
 	it "should get home" do
	 get '/'
	 expect(response.status).to eq 200
 	end

 	it "should get help" do
    get '/help'
    expect(response.status).to eq 200
  end

  it "should have the title 'help'" do
   get '/help'
   byebug
   expect(response.body).to have_title("Help | Ruby on Rails Tutorial Sample App")
 end

  it "should get about" do
    get '/about'
    expect(response.status).to eq 200
  end

  it "should get Contact" do
    get '/contact'
    expect(response.status).to eq 200
  end


end