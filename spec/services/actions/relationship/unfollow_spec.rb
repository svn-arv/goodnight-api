require 'rails_helper'

RSpec.describe Actions::Relationship::Unfollow do
  let(:user) { create(:user) }
  let(:following) { create(:user) }

  before do
    create(:relationship, user: user, following: following)
  end

  describe '#call' do
    it 'removes a relationship when it exists' do
      expect do
        described_class.call(user: user, following: following)
      end.to change(Relationship, :count).by(-1)
    end

    it 'does nothing when user is nil' do
      expect do
        described_class.call(user: nil, following: following)
      end.not_to change(Relationship, :count)
    end

    it 'does nothing when following is nil' do
      expect do
        described_class.call(user: user, following: nil)
      end.not_to change(Relationship, :count)
    end

    it 'does nothing when user and following are the same' do
      expect do
        described_class.call(user: user, following: user)
      end.not_to change(Relationship, :count)
    end

    it 'does nothing when no relationship exists' do
      other_user = create(:user)

      expect do
        described_class.call(user: user, following: other_user)
      end.not_to change(Relationship, :count)
    end

    it 'uses advisory locks for safety' do
      expect_any_instance_of(described_class).to receive(:with_advisory_lock).with(Relationship).and_call_original
      described_class.call(user: user, following: following)
    end
  end
end
