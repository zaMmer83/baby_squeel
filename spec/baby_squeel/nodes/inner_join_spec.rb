require 'spec_helper'
require 'shared_examples/join_equality'

describe BabySqueel::Nodes::InnerJoin do
  include_examples 'join equality' do
    let(:equivalent_node) { Arel::Nodes::InnerJoin }
  end

  describe '#eql?' do
    it 'can be a symbol' do
      is_expected.to eql(:author)
    end

    it 'can be a hash' do
      is_expected.to eql(author: {})
    end
  end
end
