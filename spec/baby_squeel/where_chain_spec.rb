require 'spec_helper'

describe BabySqueel::WhereChain do
  describe '#has' do
    it 'generates proper sql' do
      relation = Post.where.has {
        title.eq('OJ Simpson')
      }

      expect(relation.to_sql).to eq(<<-EOSQL.squish)
        SELECT "posts".* FROM "posts"
        WHERE "posts"."title" = 'OJ Simpson'
      EOSQL
    end

    it 'handles complex conditions' do
      relation = Post.where.has {
        title.matches('Simp%').or(
          title.eq('meatloaf')
        )
      }

      expect(relation.to_sql).to eq(<<-EOSQL.squish)
        SELECT "posts".* FROM "posts"
        WHERE ("posts"."title" LIKE 'Simp%' OR "posts"."title" = 'meatloaf')
      EOSQL
    end
  end
end
