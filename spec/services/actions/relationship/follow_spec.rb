require 'rails_helper'

RSpec.describe Actions::Relationship::Follow do
  let(:user) { create(:user) }
  let(:following) { create(:user) }

  describe '#call' do
    it 'creates a relationship when users exist and are different' do
      expect do
        described_class.call(user: user, following: following)
      end.to change(Relationship, :count).by(1)
    end

    it 'does not create a relationship when user is nil' do
      expect do
        described_class.call(user: nil, following: following)
      end.not_to change(Relationship, :count)
    end

    it 'does not create a relationship when following is nil' do
      expect do
        described_class.call(user: user, following: nil)
      end.not_to change(Relationship, :count)
    end

    it 'does not create a relationship when user and following are the same' do
      expect do
        described_class.call(user: user, following: user)
      end.not_to change(Relationship, :count)
    end

    it 'does not create duplicate relationships' do
      # First create the relationship
      described_class.call(user: user, following: following)

      # Try to create it again
      expect do
        described_class.call(user: user, following: following)
      end.not_to change(Relationship, :count)
    end

    it 'uses advisory locks for safety' do
      expect_any_instance_of(described_class).to receive(:with_advisory_lock).with(Relationship).and_call_original
      described_class.call(user: user, following: following)
    end
  end
end
