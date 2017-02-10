require 'spec_helper'

describe BabySqueel::CalculationProxy do
  describe '.wrap' do
    if ActiveRecord::VERSION::MAJOR >= 5
      it 'always returns identity' do
        expect(described_class.wrap(1)).to eq(1)
      end
    else
      it 'returns a CalculationProxy' do
        expect(described_class.new(1)).to be_a(BabySqueel::CalculationProxy)
      end
    end
  end

  describe '#to_s' do
    it 'returns the node' do
      expect(described_class.new(1).to_s).to eq(1)
    end
  end
end
