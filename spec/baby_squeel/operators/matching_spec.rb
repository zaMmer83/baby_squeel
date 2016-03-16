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

  describe '#like' do
    subject { attribute.like 'meat%' }
    specify { is_expected.to produce_sql %("posts"."title" LIKE 'meat%') }
  end

  describe '#like_any' do
    let(:sql) { %(("posts"."title" LIKE 'meat%' OR "posts"."title" LIKE '%jawn')) }
    subject { attribute.like_any ['meat%', '%jawn'] }
    specify { is_expected.to produce_sql sql }
  end

  describe '#!~' do
    subject { attribute !~ '%loaf' }
    specify { is_expected.to produce_sql %("posts"."title" NOT LIKE '%loaf') }
  end

  describe '#not_like' do
    subject { attribute.not_like '%loaf' }
    specify { is_expected.to produce_sql %("posts"."title" NOT LIKE '%loaf') }
  end

  describe '#not_like_any' do
    let(:sql) { %(("posts"."title" NOT LIKE '%loaf' OR "posts"."title" NOT LIKE 'jawn%')) }
    subject { attribute.not_like_any ['%loaf', 'jawn%'] }
    specify { is_expected.to produce_sql sql }
  end
end
