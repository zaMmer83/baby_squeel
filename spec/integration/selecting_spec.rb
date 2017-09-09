require 'spec_helper'

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

  it 'selects on an aliased table' do
    relation = Post.joins(author: :posts).selecting {
      author.posts.id
    }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT "posts_authors"."id" FROM "posts"
      INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      INNER JOIN "posts" "posts_authors" ON "posts_authors"."author_id" = "authors"."id"
    EOSQL
  end
end
