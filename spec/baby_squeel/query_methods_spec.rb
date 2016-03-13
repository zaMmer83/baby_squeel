require 'spec_helper'

describe BabySqueel::QueryMethods do
  describe '#selecting' do
    it 'selects using arel' do
      relation = Post.selecting { [id, title] }

      expect(relation.to_sql.squish).to eq(<<-EOSQL.squish)
        SELECT "posts"."id", "posts"."title"
        FROM "posts"
      EOSQL
    end

    it 'selects aggregates' do
      relation = Post.selecting { id.count }

      expect(relation.to_sql.squish).to eq(<<-EOSQL.squish)
        SELECT COUNT("posts"."id")
        FROM "posts"
      EOSQL
    end

    it 'selects associations' do
      relation = Post.joins(:author).selecting {
        [id, author[:id]]
      }

      expect(relation.to_sql.squish).to eq(<<-EOSQL.squish)
        SELECT "posts"."id", "authors"."id"
        FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end
  end

  describe '#ordering' do
    it 'orders using arel' do
      relation = Post.ordering { title.desc }

      expect(relation.to_sql.squish).to eq(<<-EOSQL.squish)
        SELECT "posts".* FROM "posts"
        ORDER BY "posts"."title" DESC
      EOSQL
    end

    it 'orders using multiple arel columns' do
      relation = Post.ordering {
        [title.desc, published_at.asc]
      }

      expect(relation.to_sql.squish).to eq(<<-EOSQL.squish)
        SELECT "posts".* FROM "posts"
        ORDER BY "posts"."title" DESC, "posts"."published_at" ASC
      EOSQL
    end

    it 'orders on an aggregate column' do
      relation = Post.ordering { id.count }.group(:id)

      expect(relation.to_sql.squish).to eq(<<-EOSQL.squish)
        SELECT "posts".* FROM "posts"
        GROUP BY "posts"."id"
        ORDER BY COUNT("posts"."id")
      EOSQL
    end
  end
end
