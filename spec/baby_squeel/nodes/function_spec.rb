require 'spec_helper'
require 'baby_squeel/nodes'
require 'shared_examples/operations'
require 'shared_examples/like_operations'

describe BabySqueel::Nodes::Function do
  let(:function) {
    BabySqueel::Nodes::Function.new('coalesce', [
      Post.arel_table[:id],
      Post.arel_table[:author_id]
    ])
  }

  it_behaves_like 'a node with operations' do
    let(:attribute)     { function }
    let(:attribute_sql) { 'coalesce("posts"."id", "posts"."author_id")' }

    let(:string_attribute_sql) {
      %(coalesce("posts"."title", 'FALLBACK'))
    }
  end

  it_behaves_like 'a node with like operations' do
    let(:attribute_sql) { %(coalesce("posts"."title", 'FALLBACK')) }

    let(:attribute) {
      BabySqueel::Nodes::Function.new('coalesce', [
        Post.arel_table[:title],
        Arel.sql("'FALLBACK'")
      ])
    }
  end

  describe '#asc' do
    it 'uses arels built in sorting sql' do
      sql = 'coalesce("posts"."id", "posts"."author_id") ASC'
      expect(function.asc).to produce_sql(sql)
    end
  end

  describe '#desc' do
    it 'uses arels built in sorting sql' do
      sql = 'coalesce("posts"."id", "posts"."author_id") DESC'
      expect(function.desc).to produce_sql(sql)
    end
  end
end
