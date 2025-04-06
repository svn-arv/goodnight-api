require 'rails_helper'

RSpec.describe Actions::Base do
  describe 'self.call' do
    before do
      allow(ActiveRecord::Base).to receive(:transaction)
    end

    it 'wraps execution in a transaction' do
      described_class.call(should_succeed: true)
      expect(ActiveRecord::Base).to have_received(:transaction)
    end
  end

  describe '.call' do
    let(:test_class) do
      Class.new(described_class) do
        def call(should_succeed: true)
          raise StandardError, 'Failed operation' unless should_succeed

          { result: 'success' }
        end
      end
    end

    it 'sets success to true when operation succeeds' do
      result = test_class.call(should_succeed: true)
      expect(result.success?).to be true
    end

    it 'sets success to false when operation fails' do
      result = test_class.call(should_succeed: false)
      expect(result.success?).to be false
    end

    it 'stores the error when operation fails' do
      result = test_class.call(should_succeed: false)
      expect(result.error_message).to include('Failed operation')
    end

    it 'stores the result when operation succeeds' do
      result = test_class.call(should_succeed: true)
      expect(result.result).to eq({ result: 'success' })
    end
  end

  describe '#with_advisory_lock' do
    let(:instance) { described_class.new }
    let(:model_class) { class_double(ActiveRecord::Base, with_advisory_lock: 'test_table', table_name: 'test_table') }

    it 'calls with_advisory_lock with the table name' do
      instance.with_advisory_lock(model_class)
      expect(model_class).to have_received(:with_advisory_lock).with('test_table')
    end
  end

  describe '#paginate' do
    let(:instance) { described_class.new }
    let(:collection) { class_double(ActiveRecord::Relation) }
    let(:pagination_instance) { instance_double(Helpers::Pagination) }
    let(:pagination_result) { { items: [], pagination: {} } }

    before do
      allow(Helpers::Pagination).to receive(:new).and_return(pagination_instance)
      allow(pagination_instance).to receive(:paginate).and_return(pagination_result)
    end

    it 'delegates pagination to Helpers::Pagination' do
      instance.paginate(collection, page: 1, per_page: 25)
      expect(Helpers::Pagination).to have_received(:new).with(page: 1, per_page: 25)
      expect(pagination_instance).to have_received(:paginate).with(collection)
    end

    it 'returns the result from the pagination helper' do
      result = instance.paginate(collection, page: 1, per_page: 25)
      expect(result).to eq(pagination_result)
    end
  end
end
