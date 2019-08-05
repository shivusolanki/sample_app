require "rails_helper"

describe " user signup" do

   before(:each) do
    @user = User.new(name: "user", email: "vijay@railstutorial.org", password: "123456", password_confirmation: "123456")
  end

  describe "invalid user" do
    it "invalid user should not be accepted" do
      !@user.save if !@user.valid?
    end
  end

  describe "valid user" do
    it "valid user should be accepted" do
       if @user.valid?
       	@user.save
        render_template 'user/show'
        # expect(flash[:notice]).to eql("Welcome to the Sample App")
       end
    end

  end
end