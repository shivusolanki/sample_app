require "rails_helper"

describe "login" do
	 def setup
    @user = users(:michael)
  end
  .
	it "login with invalid information" do
		get '/login'
		render_template 'sessions/new'
		post '/login', params: { session: { email: "", password: "" } }
		  render_template 'sessions/new'
			!flash.empty?
    	get '/'
      flash.empty?
    end

    it "login with valid information" do
    	get '/login'
    	post '/login', params: { session: { email: @user.email, password: "password" } }
    	expect(response).to redirect_to(assigns(@user))
      follow_redirect!
    	expect(response).to render_template('users/show')
    	


end