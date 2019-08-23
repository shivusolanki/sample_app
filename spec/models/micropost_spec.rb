require '../rails_helper'

describe Micropost do
	let(:user) {User.new(name: "Example User", email: "example485@railstutorial.org",
		                 password: "123456", password_confirmation: "123456") }
	before do
		user.save
		@micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
  end

  subject {@micropost}

  it { should respond_to(:content)}
  it { should respond_to(:user_id)}
  it { should be_valid }

  context "when user_is is not present" do
  	before { @micropost.user_id = nil }
  	it { should_not be_valid }
  end

  context "with blank content" do
  	before { @micropost.content = " " }
  	it { should_not be_valid }
  end

  context "with content that is too long " do
  	before { @micropost.content = "a" * 141 }
  	it { should_not be_valid }
  end
end