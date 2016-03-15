require 'spec_helper'
require 'baby_squeel/operators'

describe BabySqueel::Operators::Generic do
  let(:proxy) {
    Class.new(BabySqueel::Nodes::Proxy) {
      include BabySqueel::Operators::Generic
    }
  }

  let(:attribute) {
    proxy.new(Post.arel_table[:title])
  }

  describe '#op' do
    let(:sql) { %("posts"."title" || 'dizzle') }
    subject   { attribute.op('||', Arel.sql("'dizzle'")) }
    specify   { is_expected.to produce_sql sql }
  end
end
