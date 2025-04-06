require 'rails_helper'

RSpec.describe Actions::SleepRecord::Read do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  before do
    # Create some sleep records for testing
    3.times { |i| create(:sleep_record, user: user, start_at: 1.day.ago + i.minutes) }
    2.times { |i| create(:sleep_record, user: another_user, start_at: 2.days.ago + i.minutes) }
  end

  describe '.call' do
    context 'with user filter' do
      it 'returns only records for the specified user' do
        result = described_class.call(filters: { user_id: user.id })
        expect(result.success?).to be true
        expect(result.result.count).to eq(3)
        expect(result.result.pluck(:user_id).uniq).to eq([user.id])
      end
    end

    context 'with custom ordering' do
      it 'orders records according to specified order' do
        result = described_class.call(filters: {}, order: { created_at: :asc })
        expect(result.success?).to be true
        expect(result.result.first.created_at).to be < result.result.last.created_at
      end
    end

    context 'with scopes' do
      it 'applies the on_or_before scope' do
        date = 1.5.days.ago
        result = described_class.call(
          filters: {},
          scopes: [[:on_or_before, :start_at, date]]
        )
        expect(result.success?).to be true
        expect(result.result.count).to eq(2) # Only records from another_user (2 days ago)
      end

      it 'applies the on_or_after scope' do
        date = 1.5.days.ago
        result = described_class.call(
          filters: {},
          scopes: [[:on_or_after, :start_at, date]]
        )
        expect(result.success?).to be true
        expect(result.result.count).to eq(3) # Only records from user (1 day ago)
      end
    end

    context 'with pagination' do
      it 'paginates the results' do
        allow_any_instance_of(described_class).to receive(:paginate).and_call_original

        result = described_class.call(
          filters: {},
          pagination_params: { page: 1, per_page: 2 }
        )

        expect(result.success?).to be true
        expect(result.result.size).to eq(2)
      end
    end

    context 'without pagination' do
      it 'returns all matching records' do
        result = described_class.call(filters: {})
        expect(result.success?).to be true
        expect(result.result.size).to eq(5)
      end
    end

    context 'when an error occurs' do
      before do
        allow_any_instance_of(described_class).to receive(:call).and_raise(StandardError.new('Test error'))
      end

      it 'handles the error and returns failure' do
        result = described_class.call(filters: {})
        expect(result.success?).to be false
        expect(result.error_message).to eq('Test error')
      end
    end
  end
end
