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
    let(:relation)    { BabySqueel::Relation.new(Author) }
    let(:reflection)  { Author.reflect_on_association(:posts) }

    context 'when inner joining' do
      let(:association) { BabySqueel::Association.new(relation, reflection) }
      subject { table._arel([association]) }
      specify { is_expected.to be_a(Hash) }
    end

    context 'when outer joining' do
      let(:association) { BabySqueel::Association.new(relation, reflection).outer }
      subject { table._arel([association]) }
      specify { is_expected.to be_a(BabySqueel::JoinExpression) }
    end

    context 'when not joining' do
      subject { table._arel }
      specify { is_expected.to eq(nil) }
    end
  end
end
