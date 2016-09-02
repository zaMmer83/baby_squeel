require 'spec_helper'

describe BabySqueel::ActiveRecord::JoinsValues do
  subject(:joins_values) { described_class.new([]) }

  let(:arel_join) { make_join Arel::Nodes::InnerJoin }
  let(:bs_join)   { make_join BabySqueel::Nodes::InnerJoin, :author }

  def make_join(klass, *args)
    authors = Author.arel_table
    posts = Post.arel_table
    on = Arel::Nodes::On.new(posts[:author_id].eq(authors[:id]))
    klass.new(authors, on, *args)
  end

  describe '#+' do
    it 'can be added to' do
      expect(joins_values + [1]).to eq([1])
    end

    it 'always returns a JoinsValues' do
      expect(joins_values + [1]).to be_a(described_class)
    end

    it 'dedupes when given a symbol then a BabySqueel::Nodes::InnerJoin' do
      expect(bs_join).to eql(:author) # sanity check
      expect(joins_values + [bs_join] + [:author]).to eq([bs_join])
    end

    it 'dedupes when given a BabySqueel::Nodes::InnerJoin then a symbol' do
      expect(joins_values + [:author] + [bs_join]).to eq([bs_join])
    end

    it 'dedupes Arel::Nodes::InnerJoin and a BabySqueel::Nodes::InnerJoin' do
      expect(joins_values + [bs_join] + [arel_join]).to eq([bs_join])
    end

    it 'does not dedupe two symbols' do
      expect(joins_values + [:author] + [:author]).to eq([:author, :author])
    end

    it 'does not dedupe two Arel::Nodes::InnerJoins (Active Record will handle it)' do
      expect(joins_values + [arel_join] + [arel_join]).to eq([arel_join, arel_join])
    end
  end
end
