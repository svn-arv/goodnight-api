require 'rails_helper'

RSpec.describe Relationship do
  let(:relationship) { create(:relationship) }

  it 'enforces unique user-following combination' do
    duplicate = described_class.new(user: relationship.user, following: relationship.following)
    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:user_id]).to include('has already been taken')
  end

  describe 'scopes' do
    it 'returns followers for a user' do
      followers = described_class.followers(user2)
      expect(followers.count).to eq(1)
      expect(followers.first.user).to eq(user1)
    end

    it 'returns followings for a user' do
      followings = described_class.followings(user1)
      expect(followings.count).to eq(1)
      expect(followings.first.following).to eq(user2)
    end
  end
end
