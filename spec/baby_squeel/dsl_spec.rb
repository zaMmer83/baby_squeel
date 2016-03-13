require 'spec_helper'
require 'baby_squeel/dsl'

describe BabySqueel::DSL do
  subject(:dsl) { BabySqueel::DSL.new(Post) }

  describe '#respond_to?' do
    it 'resolves attributes' do
      expect(dsl.respond_to?(:id)).to eq(true)
    end

    it 'resolves associations' do
      expect(dsl.respond_to?(:author)).to eq(true)
    end
  end

  describe '#method_missing' do
    it 'resolves attributes' do
      expect(dsl.id).to be_an(Arel::Attribute)
    end

    it 'resolves associations' do
      expect(dsl.author).to eq(Author.arel_table)
    end

    it 'does not resolve when arguments are given' do
      expect { dsl.id(:arg) }.to raise_error(NameError)
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
        dsl.evaluate { |t| that = self }
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
        expect(resolution).to eq(Post.arel_table[:title])
      end
    end
  end

  describe '#[]' do
    it 'returns an arel attribute' do
      expect(dsl[:title]).to be_an(Arel::Attribute)
    end
  end

  describe '#func' do
    it 'constructs a named function' do
      expect(dsl.func(:coalesce, 0, 1).to_sql).to eq('coalesce(0, 1)')
    end
  end
end
