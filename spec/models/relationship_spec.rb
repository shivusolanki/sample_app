require '../rails_helper'

describe Relationship do
	let(:follower) { FactoryBot.create(:user) }
	let(:followed) { FactoryBot.create(:user) }
	let(:relationship) { follower.active_relationships.build(followed_id: followed.id) }

	subject { relationship }

	it { should be_valid }

	context "follower methods" do
		it { should respond_to(:follower) }
		it { should respond_to(:followed) }
		it { should respond_to(:follower_id) }
		it { should respond_to(:followed_id) }
	end

	context "when followed_id is not present" do
		before { relationship.followed_id = nil }
		it { should_not be_valid }
	end

	context "when follower_id is present" do
		before { relationship.follower_id = nil }
		it { should_not be_valid }
	end
end