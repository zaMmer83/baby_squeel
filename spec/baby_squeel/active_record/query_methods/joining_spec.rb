require 'spec_helper'

describe BabySqueel::ActiveRecord::QueryMethods, '#joining' do
  context 'when joining explicitly' do
    it 'inner joins' do
      relation = Post.joining {
        author.on(author.id == author_id)
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end

    it 'inner joins explicitly' do
      relation = Post.joining {
        author.inner.on(author.id == author_id)
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end

    it 'outer joins' do
      relation = Post.joining {
        author.outer.on(author.id == author_id)
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        LEFT OUTER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end

    it 'self joins' do
      relation = Post.joining { on(id == 1) }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "posts" ON "posts"."id" = 1
      EOSQL
    end

    it 'self outer joins' do
      relation = Post.joining { outer.on(id == 1) }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        LEFT OUTER JOIN "posts" ON "posts"."id" = 1
      EOSQL
    end

    it 'self joins with alias' do
      relation = Post.joining {
        on(id == 1).alias('meatloaf')
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "posts" "meatloaf" ON "posts"."id" = 1
      EOSQL
    end

    it 'aliases' do
      relation = Post.joining {
        author.alias('a').on(author.id == author_id)
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" "a" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end

    it 'aliases after the on clause' do
      relation = Post.joining {
        author.on(author.id == author_id).alias('a')
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" "a" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end

    context 'with complex conditions' do
      it 'inner joins' do
        relation = Post.joining {
          author.on(
            (author_id == author.id) & (author.id != 5) | (author.name == nil)
          )
        }

        expect(relation).to produce_sql(<<-EOSQL)
          SELECT "posts".* FROM "posts"
          INNER JOIN "authors" ON ("posts"."author_id" = "authors"."id"
            AND "authors"."id" != 5 OR "authors"."name" IS NULL)
        EOSQL
      end

      it 'outer joins' do
        relation = Post.joining {
          author.outer.on(
            (author_id == author.id) & (author.id != 5) | (author.name == nil)
          )
        }

        expect(relation).to produce_sql(<<-EOSQL)
          SELECT "posts".* FROM "posts"
          LEFT OUTER JOIN "authors" ON ("posts"."author_id" = "authors"."id"
            AND "authors"."id" != 5 OR "authors"."name" IS NULL)
        EOSQL
      end
    end
  end

  context 'when joining implicitly' do
    it 'inner joins' do
      relation = Post.joining { author }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end

    it 'outer joins' do
      relation = Post.joining { author.outer }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        LEFT OUTER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      EOSQL
    end

    describe 'nested joins' do
      it 'inner joins' do
        relation = Post.joining { author.comments }

        expect(relation).to produce_sql(<<-EOSQL)
          SELECT "posts".* FROM "posts"
          INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
          INNER JOIN "comments" ON "comments"."author_id" = "authors"."id"
        EOSQL
      end

      it 'outer joins' do
        relation = Post.joining { author.outer.comments }

        expect(relation).to produce_sql(<<-EOSQL)
          SELECT "posts".* FROM "posts"
          LEFT OUTER JOIN "authors" ON "authors"."id" = "posts"."author_id"
          INNER JOIN "comments" ON "comments"."author_id" = "authors"."id"
        EOSQL
      end

      it 'outer joins at multiple levels' do
        relation = Post.joining { author.outer.comments.outer }

        expect(relation).to produce_sql(<<-EOSQL)
          SELECT "posts".* FROM "posts"
          LEFT OUTER JOIN "authors" ON "authors"."id" = "posts"."author_id"
          LEFT OUTER JOIN "comments" ON "comments"."author_id" = "authors"."id"
        EOSQL
      end

      it 'outer joins only the specified associations' do
        relation = Post.joining { author.comments.outer }

        expect(relation).to produce_sql(<<-EOSQL)
          SELECT "posts".* FROM "posts"
          INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
          LEFT OUTER JOIN "comments" ON "comments"."author_id" = "authors"."id"
        EOSQL
      end
    end

    it 'raises an error when attempting to alias an inner join' do
      expect {
        Post.joining { author.alias('a') }.to_sql
      }.to raise_error(BabySqueel::AliasingError, /'author' as 'a'/)
    end

    it 'raises an error when attempting to alias an outer join' do
      expect {
        Post.joining { author.outer.alias('a') }.to_sql
      }.to raise_error(BabySqueel::AliasingError, /'author' as 'a'/)
    end
  end
end
