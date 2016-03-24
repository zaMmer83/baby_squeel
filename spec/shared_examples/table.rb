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

  describe '#association' do
    it 'builds a table from the associated class' do
      expect(table.association(:author)).to be_a(BabySqueel::Table)
    end

    it 'allows chaining attributes' do
      assoc = table.association :author
      expect(assoc.id).to be_a(Arel::Attributes::Attribute)
    end

    it 'raises an error for non-existant associations' do
      expect {
        table.association :non_existent
      }.to raise_error(
        BabySqueel::AssociationNotFoundError,
        /named 'non_existent'(.+)on Post/
      )
    end
  end

  describe '#respond_to?' do
    it 'resolves attributes' do
      is_expected.to respond_to(:title)
    end

    it 'resolves associations' do
      is_expected.to respond_to(:author)
    end
  end

  describe '#method_missing' do
    it 'resolves attributes' do
      expect(table.id).to be_an(Arel::Attributes::Attribute)
    end

    it 'resolves associations' do
      expect(table.author).to be_a(BabySqueel::Table)
    end

    it 'does not resolve when a block is given' do
      expect { table.id { 'block' } }.to raise_error(NameError)
    end

    it 'does not resolve for non-existent columns' do
      expect { table.non_existent_column }.to raise_error(NameError)
    end
  end
end
