require 'rails_helper'

RSpec.describe Helpers::DateTime do
  describe '.parseable?' do
    context 'with valid input formats' do
      it 'returns true for ISO 8601 date' do
        expect(described_class.parseable?('2023-10-15')).to be true
      end

      it 'returns true for ISO 8601 datetime' do
        expect(described_class.parseable?('2023-10-15T13:45:30Z')).to be true
      end

      it 'returns true for RFC 2822 format' do
        expect(described_class.parseable?('Sun, 15 Oct 2023 13:45:30 -0400')).to be true
      end

      it 'returns true for natural language dates' do
        expect(described_class.parseable?('October 15, 2023')).to be true
      end

      it 'returns true for date-time with timezone' do
        expect(described_class.parseable?('2023-10-15 13:45:30 EDT')).to be true
      end
    end

    context 'with invalid input formats' do
      it 'returns false for completely invalid strings' do
        expect(described_class.parseable?('not a date')).to be false
      end

      it 'returns false for impossible dates' do
        expect(described_class.parseable?('2023-13-45')).to be false
      end
    end

    context 'with non-string inputs' do
      it 'raises an error for nil input' do
        expect(described_class.parseable?(nil)).to be false
      end

      it 'raises an error for numeric input' do
        expect(described_class.parseable?(20_231_015)).to be false
      end

      it 'raises an error for array input' do
        expect(described_class.parseable?([2023, 10, 15])).to be false
      end

      it 'raises an error for hash input' do
        expect(described_class.parseable?({ year: 2023, month: 10, day: 15 })).to be false
      end
    end
  end
end
