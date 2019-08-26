require '../rails_helper'

describe Micropost do
	let(:user) { FactoryBot.create(:user) }

	before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject {@micropost}

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  # it(:user) { should eq user }

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