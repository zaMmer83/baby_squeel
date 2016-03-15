require 'spec_helper'
require 'baby_squeel/dsl'

describe BabySqueel::DSL do
  subject(:dsl) {
    BabySqueel::DSL.new(Post)
  }

  describe '#respond_to?' do
    it 'resolves attributes' do
      expect(dsl).to respond_to(:title)
    end

    it 'resolves associations' do
      expect(dsl).to respond_to(:author)
    end
  end

  describe '#method_missing' do
    it 'resolves attributes' do
      expect(dsl.id).to be_an(Arel::Attributes::Attribute)
    end

    it 'resolves associations' do
      expect(dsl.author).to be_a(BabySqueel::DSL)
    end

    it 'resolves functions' do
      expect(dsl.coalesce(0, 1)).to be_a(Arel::Nodes::NamedFunction)
    end

    it 'does not resolve when a block is given' do
      expect { dsl.id { 'block' } }.to raise_error(NameError)
    end

    it 'does not resolve for non-existent columns' do
      expect { dsl.non_existent_column }.to raise_error(NameError)
    end
  end

  describe '#evaluate' do
    context 'when an arity is given' do
      it 'yields itself' do
        dsl.evaluate do |table|
          expect(table).to be_a(BabySqueel::DSL)
        end
      end

      it 'does not change self' do
        this = self
        that = nil
        dsl.evaluate { |_t| that = self }
        expect(that).to equal(this)
      end
    end

    context 'when no arity is given' do
      it 'changes self' do
        this = self
        that = nil
        dsl.evaluate { that = self }
        expect(that).not_to equal(this)
      end

      it 'resolves attributes without a receiver' do
        resolution = nil
        dsl.evaluate { resolution = title }
        expect(resolution).to be_an(Arel::Attributes::Attribute)
      end
    end
  end

  describe '#[]' do
    it 'returns an arel attribute' do
      expect(dsl[:title]).to be_an(Arel::Attributes::Attribute)
    end
  end

  describe '#func' do
    it 'constructs a named function' do
      expect(dsl.func(:coalesce, 0, 1)).to produce_sql('coalesce(0, 1)')
    end
  end

  describe '#association' do
    it 'builds a dsl from the associated class' do
      expect(dsl.association(:author)).to be_a(BabySqueel::DSL)
    end

    it 'allows chaining attributes' do
      assoc = dsl.association :author
      expect(assoc.id).to be_a(Arel::Attributes::Attribute)
    end

    it 'raises an error for non-existant associations' do
      expect {
        dsl.association :non_existent
      }.to raise_error(
        BabySqueel::DSL::AssociationNotFoundError,
        /named 'non_existent'(.+)on Post/
      )
    end
  end
end
