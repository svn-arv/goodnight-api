require 'rails_helper'

RSpec.describe Helpers::Pagination do
  let(:collection) { double('ActiveRecord::Relation') }
  let(:paginated_collection) { double('Paginated Collection') }

  before do
    allow(collection).to receive_messages(page: collection, per: paginated_collection)
    allow(paginated_collection).to receive(:total_count).and_return(30)
  end

  describe '#initialize' do
    it 'uses provided page and per_page values' do
      pagination = described_class.new(page: 2, per_page: 15)

      expect(pagination.instance_variable_get(:@page)).to eq(2)
      expect(pagination.instance_variable_get(:@per_page)).to eq(15)
    end

    it 'uses default values when parameters are nil' do
      pagination = described_class.new

      expect(pagination.instance_variable_get(:@page)).to eq(described_class::DEFAULT_PAGE)
      expect(pagination.instance_variable_get(:@per_page)).to eq(described_class::DEFAULT_PER_PAGE)
    end

    it 'uses default values when parameters are explicitly nil' do
      pagination = described_class.new(page: nil, per_page: nil)

      expect(pagination.instance_variable_get(:@page)).to eq(described_class::DEFAULT_PAGE)
      expect(pagination.instance_variable_get(:@per_page)).to eq(described_class::DEFAULT_PER_PAGE)
    end

    it 'accepts string values and converts them' do
      pagination = described_class.new(page: '2', per_page: '15')

      # The values remain as strings until paginate is called
      expect(pagination.instance_variable_get(:@page)).to eq('2')
      expect(pagination.instance_variable_get(:@per_page)).to eq('15')
    end
  end

  describe '#paginate' do
    it 'applies pagination with correct parameters' do
      pagination = described_class.new(page: 2, per_page: 15)

      pagination.paginate(collection)

      expect(collection).to have_received(:page).with(2)
      expect(collection).to have_received(:per).with(15)
    end

    it 'converts string parameters to integers' do
      pagination = described_class.new(page: '2', per_page: '15')

      pagination.paginate(collection)
      expect(collection).to have_received(:page).with(2)
      expect(collection).to have_received(:per).with(15)
    end

    it 'enforces minimum page number' do
      pagination = described_class.new(page: 0)

      pagination.paginate(collection)
      expect(collection).to have_received(:page).with(described_class::MINIMUM_PAGE)
    end

    it 'enforces maximum per_page value' do
      pagination = described_class.new(per_page: described_class::MAX_PER_PAGE + 10)

      pagination.paginate(collection)
      expect(collection).to have_received(:per).with(described_class::MAX_PER_PAGE)
    end

    it 'returns a hash with items and pagination info' do
      pagination = described_class.new(page: 2, per_page: 10)

      result = pagination.paginate(collection)

      expect(result).to be_a(Hash)
      expect(result).to have_key(:items)
      expect(result).to have_key(:pagination)
      expect(result[:items]).to eq(paginated_collection)
    end

    it 'includes the correct pagination metadata' do
      pagination = described_class.new(page: 2, per_page: 10)

      result = pagination.paginate(collection)

      expect(result[:pagination]).to include(
        current_page: 2,
        per_page: 10,
        total_count: 30,
        total_pages: 3 # 30 items divided by 10 per_page = 3 pages
      )
    end

    it 'calculates total_pages correctly when there is a remainder' do
      allow(paginated_collection).to receive(:total_count).and_return(35)
      pagination = described_class.new(page: 2, per_page: 10)

      result = pagination.paginate(collection)

      expect(result[:pagination][:total_pages]).to eq(4) # 35 items divided by 10 per_page = 3.5, rounded up to 4
    end

    it 'handles the edge case of zero total records' do
      allow(paginated_collection).to receive(:total_count).and_return(0)
      pagination = described_class.new(page: 1, per_page: 10)

      result = pagination.paginate(collection)

      expect(result[:pagination][:total_pages]).to eq(0)
    end

    it 'handles negative page numbers by using the minimum' do
      pagination = described_class.new(page: -5)

      pagination.paginate(collection)
      expect(collection).to have_received(:page).with(described_class::MINIMUM_PAGE)
    end
  end
end
