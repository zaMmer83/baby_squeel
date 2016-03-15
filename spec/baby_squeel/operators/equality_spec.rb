require 'spec_helper'
require 'baby_squeel/operators'

describe BabySqueel::Operators::Equality do
  let(:proxy) {
    Class.new(BabySqueel::Nodes::Proxy) {
      include BabySqueel::Operators::Equality
    }
  }

  let(:attribute) {
    proxy.new(Post.arel_table[:id])
  }

  describe '#==' do
    subject { attribute == 1 }
    specify { is_expected.to produce_sql '"posts"."id" = 1' }
  end

  describe '#!=' do
    subject { attribute != 1 }
    specify { is_expected.to produce_sql '"posts"."id" != 1' }
  end
end
