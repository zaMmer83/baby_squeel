require 'spec_helper'

describe BabySqueel::ActiveRecord::QueryMethods do
  describe '#selecting' do
    it 'selects using arel' do
      relation = Post.selecting { [id, title] }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts"."id", "posts"."title"
        FROM "posts"
      EOSQL
    end

    it 'selects associations' do
      relation = Post.joins(:author).selecting {
        [id, author.id]
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts"."id", "authors"."id"
        FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end

    it 'selects aggregates' do
      relation = Post.selecting { id.count }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT COUNT("posts"."id")
        FROM "posts"
      EOSQL
    end

    it 'selects using functions' do
      relation = Post.joins(:author).selecting {
        coalesce(id, author.id)
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT coalesce("posts"."id", "authors"."id")
        FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end

    it 'selects using operations' do
      relation = Post.joins(:author).selecting {
        author.id - id
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT ("authors"."id" - "posts"."id")
        FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end
  end

  describe '#ordering' do
    it 'orders using arel' do
      relation = Post.ordering { title.desc }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        ORDER BY "posts"."title" DESC
      EOSQL
    end

    it 'orders using multiple arel columns' do
      relation = Post.ordering {
        [title.desc, published_at.asc]
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        ORDER BY "posts"."title" DESC, "posts"."published_at" ASC
      EOSQL
    end

    it 'orders on an aggregates' do
      relation = Post.group('"posts"."id"').ordering {
        id.count.desc
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        GROUP BY "posts"."id"
        ORDER BY COUNT("posts"."id") DESC
      EOSQL
    end

    it 'orders using functions' do
      relation = Post.joins(:author).ordering {
        coalesce(id, author.id).desc
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".*
        FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        ORDER BY coalesce("posts"."id", "authors"."id") DESC
      EOSQL
    end

    it 'orders using operations' do
      relation = Post.joins(:author).ordering {
        (author.id - id).desc
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".*
        FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        ORDER BY ("authors"."id" - "posts"."id") DESC
      EOSQL
    end
  end
end
