require 'spec_helper'

describe BabySqueel::JoinDependency::Injector do
  let(:join_path) {
    BabySqueel::Join.new([])
  }

  let(:joins_values) {
    [:something, join_path, {a: :b}]
  }

  subject(:injector) { described_class.new(joins_values) }

  describe '#group_by' do
    it 'never yields JoinPath instances to the block' do
      injector.group_by do |join|
        expect(join).not_to eq(join_path)
      end
    end

    it 'groups JoinPath into :association_join' do
      buckets = injector.group_by { :other }
      expect(buckets[:other]).to eq([:something, { a: :b }])
      expect(buckets[:association_join]).to eq([join_path])
    end

    it 'can accompany other :association_joins' do
      buckets = injector.group_by { :association_join }
      expect(buckets[:association_join]).to eq(joins_values)
    end
  end
end
