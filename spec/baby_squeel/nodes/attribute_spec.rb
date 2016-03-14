require 'spec_helper'
require 'baby_squeel/nodes'
require 'shared_examples/expressions'
require 'shared_examples/operations'
require 'shared_examples/like_operations'

describe BabySqueel::Nodes::Attribute do
  let(:attribute) {
    BabySqueel::Nodes::Attribute.new(Post.arel_table, :id)
  }

  let(:attribute_sql) { '"posts"."id"' }

  it_behaves_like 'a node with operations'

  it_behaves_like 'a node with like operations' do
    let(:attribute_sql) { '"posts"."title"' }

    let(:attribute) {
      BabySqueel::Nodes::Attribute.new(Post.arel_table, :title)
    }
  end

  it_behaves_like 'a node with expressions'
end
