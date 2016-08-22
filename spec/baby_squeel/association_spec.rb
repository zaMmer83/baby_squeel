require 'spec_helper'
require 'baby_squeel/association'
require 'shared_examples/table'

describe BabySqueel::Association do
  let(:relation)   { BabySqueel::Relation.new(Author) }
  let(:reflection) { Author.reflect_on_association(:posts) }

  subject(:association) {
    BabySqueel::Association.new(relation, reflection)
  }

  it_behaves_like 'a table' do
    let(:table) { association }
  end

  describe '#_arel' do
    context 'when explicitly joining' do
      let(:condition) { association.author_id == association.author.id }
      subject(:arel)  { association.author.on(condition)._arel }

      specify { is_expected.to be_a(BabySqueel::JoinDependency) }

      it 'sets an on clause on the JoinExpression' do
        expect(arel._on).not_to be_nil
      end
    end

    context 'when implicitly joining' do
      subject(:arel) { association.author._arel }

      specify { is_expected.to be_a(BabySqueel::JoinDependency) }

      it 'does not set an on clause on the JoinExpression' do
        expect(arel._on).to be_nil
      end

      it 'throws a fit when an alias is attempted' do
        expect {
          association.author.alias('naughty')._arel
        }.to raise_error(BabySqueel::AssociationAliasingError)
      end
    end
  end
end
