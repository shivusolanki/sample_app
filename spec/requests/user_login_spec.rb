require "rails_helper"

describe "login" do
	it "login with invalid information" do
		get '/login'
		render_template 'sessions/new'
		post '/login', params: { session: { email: "", password: "" } }
		  render_template 'sessions/new'
			!flash.empty?
    	get '/'
      flash.empty?
    end
end