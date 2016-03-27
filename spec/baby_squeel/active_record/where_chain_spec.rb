require 'spec_helper'

describe BabySqueel::ActiveRecord::WhereChain do
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
      relation = Post.where.has { (id + 1) == 2 }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        WHERE ("posts"."id" + 1) = 2
      EOSQL
    end

    if ActiveRecord::VERSION::STRING < '4.2.0'
      it 'wheres using complex conditions' do
        relation = Post.joins(:author).where.has {
          (title =~ 'Simp%').or(author.name == 'meatloaf')
        }

        expect(relation).to produce_sql(<<-EOSQL)
          SELECT "posts".* FROM "posts"
          INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
          WHERE (("posts"."title" LIKE 'Simp%' OR "authors"."name" = 'meatloaf'))
        EOSQL
      end
    else
      it 'wheres using complex conditions' do
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

    it 'wheres on associations' do
      relation = Post.joins(author: :comments).where.has {
        author.comments.id > 0
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        INNER JOIN "comments" ON "comments"."author_id" = "authors"."id"
        WHERE ("comments"."id" > 0)
      EOSQL
    end

    it 'wheres on an aliased association' do
      relation = Post.joins(author: :posts).where.has {
        author.posts.id > 0
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        INNER JOIN "posts" "posts_authors" ON "posts_authors"."author_id" = "authors"."id"
        WHERE ("posts_authors"."id" > 0)
      EOSQL
    end

    it 'wheres on an aliased association with through' do
      relation = Post.joins(:comments, :author_comments).where.has {
        author_comments.id > 0
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "comments" ON "comments"."post_id" = "posts"."id"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        INNER JOIN "comments" "author_comments_posts" ON "author_comments_posts"."author_id" = "authors"."id"
        WHERE ("author_comments_posts"."id" > 0)
      EOSQL
    end

    it 'wheres on an alias with a function' do
      relation = Post.joins(author: :posts).where.has {
        coalesce(author.posts.id, 1) > 0
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        INNER JOIN "posts" "posts_authors" ON "posts_authors"."author_id" = "authors"."id"
        WHERE (coalesce("posts_authors"."id", 1) > 0)
      EOSQL
    end

    it 'wheres with a subquery' do
      relation = Post.joins(:author).where.has {
        author.id.in Author.select(:id).limit(3)
      }

      expect(relation).to produce_sql(<<-EOSQL)
        SELECT "posts".* FROM "posts"
        INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
        WHERE "authors"."id" IN (SELECT "authors"."id" FROM "authors" LIMIT 3)
      EOSQL
    end
  end
end
