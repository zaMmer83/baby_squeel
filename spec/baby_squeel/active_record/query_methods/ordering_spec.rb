require 'spec_helper'

describe BabySqueel::ActiveRecord::QueryMethods, '#ordering' do
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

  it 'orders on an aliased table' do
    relation = Post.joins(author: :posts).ordering {
      author.posts.id
    }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT "posts".* FROM "posts"
      INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      INNER JOIN "posts" "posts_authors" ON "posts_authors"."author_id" = "authors"."id"
      ORDER BY "posts_authors"."id"
    EOSQL
  end
end
