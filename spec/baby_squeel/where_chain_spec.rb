require 'spec_helper'

describe BabySqueel::WhereChain do
  describe '#has' do
    it 'wheres on an attribute' do
      relation = Post.where.has {
        title == 'OJ Simpson'
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        WHERE "posts"."title" = 'OJ Simpson'
      EOSQL
    end

    it 'wheres on associations' do
      relation = Post.joins(:author).where.has {
        author.name == 'Yo Gotti'
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        WHERE "authors"."name" = 'Yo Gotti'
      EOSQL
    end

    it 'wheres using functions' do
      relation = Post.joins(:author).where.has {
        coalesce(title, author.name) == 'meatloaf'
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        WHERE coalesce("posts"."title", "authors"."name") = 'meatloaf'
      EOSQL
    end

    it 'wheres using operations' do
      pending 'need to find a seamless way to patch all possible arel types'
      relation = Post.where.has { (id + 1) == 2 }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        WHERE "posts"."id" + 1 = 2
      EOSQL
    end

    it 'wheres using complex conditions', :pre_ar42 do
      relation = Post.joins(:author).where.has {
        (title =~ 'Simp%').or(author.name == 'meatloaf')
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        WHERE (("posts"."title" LIKE 'Simp%' OR "authors"."name" = 'meatloaf'))
      EOSQL
    end

    it 'wheres using complex conditions', :post_ar42 do
      relation = Post.joins(:author).where.has {
        (title =~ 'Simp%').or(author.name == 'meatloaf')
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        WHERE ("posts"."title" LIKE 'Simp%' OR "authors"."name" = 'meatloaf')
      EOSQL
    end
  end
end
