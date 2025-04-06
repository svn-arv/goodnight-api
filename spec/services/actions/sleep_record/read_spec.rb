require 'rails_helper'

RSpec.describe Actions::SleepRecord::Read do
  let(:user) { create(:user, name: 'test_user') }

  before do
    # Create a few sleep records
    3.times { |i| create(:sleep_record, user: user, start_at: Time.zone.now - i.days) }
  end

  describe '#call' do
    it 'returns all records matching the filters' do
      results = described_class.call(filters: { user_id: user.id })
      expect(results.count).to eq(3)
    end

    it 'applies scopes when provided' do
      # Assuming a scope like 'recent' exists on SleepRecord
      allow(SleepRecord).to receive_message_chain(:where, :recent, :order, :all).and_return([])

      described_class.call(filters: { user_id: user.id }, scopes: [:recent])

      expect(SleepRecord).to have_received(:where)
    end

    it 'returns empty collection when no records match filters' do
      results = described_class.call(filters: { user_id: -1 })
      expect(results).to be_empty
    end

    it 'orders results according to specified order' do
      custom_order = { start_at: :asc }
      allow(SleepRecord).to receive_message_chain(:where, :order, :all)

      described_class.call(filters: { user_id: user.id }, order: custom_order)

      expect(SleepRecord).to have_received(:where)
    end

    it 'paginates results when pagination params are provided' do
      results = described_class.call(
        filters: { user_id: user.id },
        pagination_params: { page: 1, per_page: 2 }
      )

      expect(results[:items].count).to eq(2)
      expect(results[:pagination][:current_page]).to eq(1)
      expect(results[:pagination][:total_pages]).to eq(2)
      expect(results[:pagination][:total_count]).to eq(3)
      expect(results[:pagination][:per_page]).to eq(2)
    end

    it 'handles the last page correctly' do
      results = described_class.call(
        filters: { user_id: user.id },
        pagination_params: { page: 2, per_page: 2 }
      )

      expect(results[:items].count).to eq(1)
      expect(results[:pagination][:current_page]).to eq(2)
    end

    it 'returns all results ordered by default when no pagination is specified' do
      results = described_class.call(filters: { user_id: user.id })

      expect(results.count).to eq(3)
      # Default ordering is by created_at: :desc
      expect(results.first.created_at).to be >= results.last.created_at
    end

    it 'returns success when finding records' do
      described_class.call(filters: { user_id: user.id })
      expect(described_class.success?).to be true
    end

    it 'tracks errors when finding records fails' do
      allow(SleepRecord).to receive(:where).and_raise(StandardError.new('Query failed'))
      described_class.call(filters: { user_id: user.id })

      expect(described_class.success?).to be false
      expect(described_class.errors.full_messages).to include('Base Query failed')
    end
  end
end
