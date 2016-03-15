require 'spec_helper'
require 'baby_squeel/nodes'
require 'baby_squeel/operators'

describe BabySqueel::Operators::Matching do
  let(:proxy) {
    Class.new(BabySqueel::Nodes::Proxy) {
      include BabySqueel::Operators::Matching
    }
  }

  let(:attribute) {
    proxy.new(Post.arel_table[:title])
  }

  describe '#=~' do
    subject { attribute =~ 'meat%' }
    specify { is_expected.to produce_sql %("posts"."title" LIKE 'meat%') }
  end

  describe '#!~' do
    subject { attribute !~ '%loaf' }
    specify { is_expected.to produce_sql %("posts"."title" NOT LIKE '%loaf') }
  end
end
