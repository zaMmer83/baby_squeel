require 'spec_helper'

shared_examples_for 'a table' do
  describe '#[]' do
    it 'returns an arel attribute' do
      expect(table[:title]).to be_an(Arel::Attributes::Attribute)
    end
  end

  describe '#outer' do
    it 'does not mutate the original instance' do
      next_table = table.outer
      expect(table._join).to eq(Arel::Nodes::InnerJoin)
      expect(next_table._join).to eq(Arel::Nodes::OuterJoin)
    end
  end

  describe '#respond_to?' do
    it 'resolves attributes' do
      is_expected.to respond_to(:title)
    end
  end

  describe '#method_missing' do
    it 'resolves attributes' do
      expect(table.id).to be_an(Arel::Attributes::Attribute)
    end

    it 'does not resolve when a block is given' do
      expect { table.id { 'block' } }.to raise_error(NameError)
    end
  end
end
