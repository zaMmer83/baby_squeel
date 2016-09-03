require 'spec_helper'
require 'shared_examples/join_equality'

describe BabySqueel::Nodes::OuterJoin do
  include_examples 'join equality' do
    let(:equivalent_node) { Arel::Nodes::OuterJoin }
  end
end
