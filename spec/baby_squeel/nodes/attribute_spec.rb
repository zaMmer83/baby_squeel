require 'spec_helper'
require 'baby_squeel/nodes'
require 'baby_squeel/table'

describe BabySqueel::Nodes::Attribute do
  subject(:attribute) {
    described_class.new(
      BabySqueel::Table.new(Post),
      :id
    )
  }

  describe '#in' do
    it 'doesnt break existing in behavior' do
      expect(attribute.in([1, 2])).to produce_sql('"posts"."id" IN (1, 2)')
    end

    it 'accepts an ActiveRecord relation' do
      relation = Post.selecting { id }.where.has { title == nil }

      expect(attribute.in(relation)).to produce_sql(<<-EOSQL)
        "posts"."id" IN (
          SELECT "posts"."id"
          FROM "posts"
          WHERE "posts"."title" IS NULL
        )
      EOSQL
    end
  end
end
