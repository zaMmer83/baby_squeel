require 'spec_helper'
require 'baby_squeel/nodes'

describe BabySqueel::Nodes::Attribute do
  it_behaves_like 'a node with operations' do
    let(:attribute_sql) { '"posts"."id"' }

    let(:attribute) {
      BabySqueel::Nodes::Attribute.new(Post.arel_table, :id)
    }
  end

  it_behaves_like 'a node with like operations' do
    let(:attribute_sql) { '"posts"."title"' }

    let(:attribute) {
      BabySqueel::Nodes::Attribute.new(Post.arel_table, :title)
    }
  end
end
