require 'spec_helper'

describe 'BabySqueel::Compat::DSL', :compat do
  subject(:dsl) { BabySqueel::DSL.new(Post) }

  describe '#`' do
    it 'creates a SQL literal' do
      expect(
        dsl.evaluate { `hello` }
      ).to be_an(Arel::Nodes::SqlLiteral)
    end
  end

  describe '#my' do
    it 'calls back to the original binding' do
      @something = 'test'

      values = dsl.evaluate do
        [@something, my { @something }]
      end

      expect(values).to eq([nil, 'test'])
    end
  end
end
