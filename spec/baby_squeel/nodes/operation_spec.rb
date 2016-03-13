require 'spec_helper'
require 'baby_squeel/nodes'

describe BabySqueel::Nodes::Operation do
  it_behaves_like 'a node with operations' do
    let(:attribute_sql) {
      '"posts"."id" + "posts"."author_id"'
    }

    let(:attribute) {
      BabySqueel::Nodes::Operation.new(
        :+,
        Post.arel_table[:id],
        Post.arel_table[:author_id]
      )
    }
  end

  it_behaves_like 'a node with like operations' do
    let(:attribute_sql) {
      %("posts"."title" || 'dizzle')
    }

    let(:attribute) {
      BabySqueel::Nodes::Operation.new(
        '||',
        Post.arel_table[:title],
        Arel.sql("'dizzle'")
      )
    }
  end
end
