require 'spec_helper'
require 'baby_squeel/nodes'

describe BabySqueel::Nodes::Generic do
  describe 'included modules' do
    subject { described_class.ancestors }
    specify { is_expected.to include(BabySqueel::Operators::Comparison) }
    specify { is_expected.to include(BabySqueel::Operators::Equality) }
    specify { is_expected.to include(BabySqueel::Operators::Generic) }
    specify { is_expected.to include(BabySqueel::Operators::Grouping) }
    specify { is_expected.to include(BabySqueel::Operators::Matching) }
  end
end
