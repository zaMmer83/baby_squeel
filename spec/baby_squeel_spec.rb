require 'spec_helper'

describe BabySqueel do
  describe '.[]' do
    it 'accepts a model' do
      expect(BabySqueel[Post]).to be_a(BabySqueel::Relation)
    end

    it 'accepts an Arel::Table' do
      expect(BabySqueel[Post.arel_table]).to be_a(BabySqueel::Table)
    end

    it 'accepts a symbol' do
      expect(BabySqueel[:posts]).to be_a(BabySqueel::Table)
    end
  end
end
