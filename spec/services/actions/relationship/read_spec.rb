require 'rails_helper'

RSpec.describe Actions::Relationship::Read do
  let(:user) { create(:user) }
  let(:first_follower) { create(:user) }
  let(:second_follower) { create(:user) }

  before do
    create(:relationship, user: first_follower, following: user)
    create(:relationship, user: second_follower, following: user)
  end

  describe '#call' do
    it 'returns relationships matching the filter' do
      result = described_class.call(filters: { following_id: user.id })

      expect(result).to be_success
      expect(result.result.count).to eq(2)
      expect(result.result.pluck(:user_id)).to include(first_follower.id, second_follower.id)
    end

    it 'applies the given order' do
      # Create relationship with different timestamps
      rel1 = create(:relationship, user: user, following: first_follower, created_at: 2.days.ago)
      rel2 = create(:relationship, user: user, following: second_follower, created_at: 1.day.ago)

      result = described_class.call(
        filters: { user_id: user.id },
        order: { created_at: :asc }
      )

      expect(result.result.first).to eq(rel1)
      expect(result.result.last).to eq(rel2)
    end

    it 'paginates results when pagination params are provided' do
      # Create more relationships to test pagination
      3.times { create(:relationship, user: user, following: create(:user)) }

      result = described_class.call(
        filters: { user_id: user.id },
        pagination_params: { page: 1, per_page: 2 }
      )

      expect(result.result[:items].count).to eq(2)
      expect(result.result[:pagination][:current_page]).to eq(1)
      expect(result.result[:pagination][:total_count]).to eq(3)
    end
  end
end
