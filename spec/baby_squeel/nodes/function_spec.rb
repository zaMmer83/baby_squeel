require 'spec_helper'
require 'baby_squeel/nodes/node'

describe BabySqueel::Nodes::Function do
  subject(:node) {
    described_class.new(
      Arel::Nodes::NamedFunction.new('coalesce', [
        Post.arel_table[:id],
        42
      ])
    )
  }

  it 'has math operators' do
    expect((node + 5) * 5).to produce_sql('(coalesce("posts"."id", 42) + 5) * 5')
  end
end
