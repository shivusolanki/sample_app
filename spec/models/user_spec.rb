require '../rails_helper'

describe User do
	before(:each) do
		@user = User.new(name: "Example User", email: "example485@railstutorial.org",
		                 password: "123456", password_confirmation: "123456")
	end

  let(:other_user) { User.new(name: "Example User", email: "example455@railstutorial.org",
                     password: "123456", password_confirmation: "123456")
                    }
  subject{ @user }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:active_relationships) }
  it { should respond_to(:passive_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following) }

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
		  expect(@user.valid?).to be false
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

  it "has one buyer" do
    assc = User.reflect_on_association(:microposts)
    expect(assc.macro).to eq :has_many
  end

  it "when password doesn't match with password_confirmation" do
  	@user.password = "123456"
  	@user.password_confirmation = "654321"
  	expect(@user.valid?). to be false
  end

  context "return value of authenticate method" do
  	before { @user.save}
  	let(:found_user) { User.find_by(email: @user.email)}

  	it "with valid password" do
  		# skip
  		expect(found_user.authenticate(@user.password)).to eql (@user)
  	end

    context "with invalid password" do
  		let(:user_for_invalid_password) { found_user.authenticate("invalid")}

  		it { expect(user_for_invalid_password).to be false}
  	end
  end

  context "remember token" do
    before { @user.remember }
    it{ expect(@user.remember_token).not_to be_blank }
  end

  it "should forgot" do
    @user.forget
    expect(@user.remember_digest).to be_nil
  end

  it "should follow" do
    other_user.save
    @user.follow(other_user)
    expect(@user.following).to include(other_user)
  end


  it "should unfollow" do
   other_user.save
    @user.unfollow(other_user)
    expect(@user.following).not_to include(other_user)
  end

  it "is following?" do
    other_user.save
    expect(@user.following?(other_user)).to be false
    @user.follow(other_user)
    expect(@user.following?(other_user)).to be true
  end
   
  it "should create reset digest" do
   @user.save
   expect(@user.reset_digest).to be_nil
   @user.create_reset_digest
   expect(@user.reset_digest).not_to be_nil
  end

  it "sends an email" do
    @user.save
    expect { @user.send_activation_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end 

  # it "should send password reset email" do
  #   expect { @user.send_password_reset_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
  # end 

  it "test password_reset_expired?" do
    @user.save
    @user.reset_sent_at = Time.zone.now - 1.hour
    expect(@user.password_reset_expired?).to be false
    @user.reset_sent_at = Time.zone.now - 3.hour
    expect(@user.password_reset_expired?).to be true
  end
    
  it "should activate" do
    @user.save
    @user.activate
    expect(@user.activated).to be true
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryBot.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:new_micropost) do
      FactoryBot.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
    expect(@user.microposts.to_a).to eq [new_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
    end
  end

    describe "status" do
      let(:unfollowed_post) do 
        FactoryBot.create(:micropost, user: FactoryBot.create(:user)) 
      end

      it "should include new_micropost" do
        expect(@user.feed).to include(new_micropost)
      end

      it "should include new_micropost" do
        expect(@user.feed).to include(older_micropost)
      end

      it "should include new_micropost" do
        expect(@user.feed).not_to include(unfollowed_post)
      end
    end
  end 
end