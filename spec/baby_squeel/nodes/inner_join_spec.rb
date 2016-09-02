require 'spec_helper'
require 'shared_examples/join_equality'

describe BabySqueel::Nodes::InnerJoin do
  include_examples 'join equality' do
    let(:equivalent_node) { Arel::Nodes::InnerJoin }
  end
end
