require 'spec_helper'
require 'baby_squeel/table'
require 'shared_examples/table'

describe BabySqueel::Table do
  subject(:table) {
    BabySqueel::Table.new(
      Arel::Table.new(:posts)
    )
  }

  include_examples 'a table'

  describe '#_arel' do
    context 'when joining' do
      let(:association) { instance_double BabySqueel::Association }
      subject { table._arel([association]) }
      specify { is_expected.to be_a(BabySqueel::JoinExpression) }
    end

    context 'when not joining' do
      subject { table._arel }
      specify { is_expected.to eq(nil) }
    end
  end
end
