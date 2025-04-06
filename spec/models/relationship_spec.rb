require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:first_user) { create(:user) }
  let(:second_user) { create(:user) }
  let!(:relationship) { create(:relationship, user: first_user, following: second_user) }

  describe '.create' do
    let(:attributes) { { user: relationship.user, following: relationship.following } }

    it 'enforces unique user-following combination' do
      expect { described_class.create!(attributes) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe 'scopes' do
    it 'returns followers for a user' do
      followers = described_class.followers(second_user)
      expect(followers.count).to eq(1)
      expect(followers.first.user).to eq(first_user)
    end

    it 'returns followings for a user' do
      followings = described_class.followings(first_user)
      expect(followings.count).to eq(1)
      expect(followings.first.following).to eq(second_user)
    end
  end
end
