require 'rails_helper'

describe User do
	before(:each) do
		@user = User.new(name: "Example User", email: "example485@railstutorial.org", password: "123456", password_confirmation: "123456")
	end

	it "should be valid" do
		expect(@user.valid?).to be true
	end

	it "name should not be blank" do
		@user.name = "  "
		expect(@user.valid?).to be false
	end

	it "email should be present" do
		@user.email = " "
		expect(@user.valid?).to be false
	end

	it "name should not be too long" do
		@user.name = "a" *51
		expect(@user.valid?).to be false
	end

	it "email should not be more than 225" do
	  @user.email = "a"*244 + "@example.com"
		expect(@user.valid?).to be false
	end

	it "email validation should accept valid address" do
		addresses = %w[shivu@gmail.com vij_ay@gmail.com akasg12@hsjk.com]
		addresses.each do |address|
			@user.email = address
		expect(@user.valid?).to be true
		end
	end

	it "email validation should not accept invalid address" do
		addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
		addresses.each do |address|
			@user.email = address
		expect(@user.valid?).to be true
		end
	end
  
  it "email should be unique" do
  	duplicate_user =@user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	expect(duplicate_user.valid?).to be false
  end

  it" email should be saved as lowercase" do
  	mixed_email = "FOO@gmAil.CoM"
  	@user.email = mixed_email
  	@user.save
  	expect(@user.reload.email).to eq(mixed_email.downcase)
  end

  it " password should not be blank" do
  	@user.password = @user.password_confirmation = " " *6
  	expect(@user.valid?).to be false
  end

  it " password length should not be less than 6" do
  	@user.password = @user.password_confirmation = "a" *5
  	expect(@user.valid?).to be false
  end


end
