require 'spec_helper'

describe '#grouping' do
  it 'groups on a column' do
    relation = Post.selecting { id.count }.grouping { author_id }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts"."id") FROM "posts"
      GROUP BY "posts"."author_id"
    EOSQL
  end

  it 'groups on a calculation' do
    relation = Post.selecting { id.count }.grouping {
      (author_id + 1) + 5
    }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts"."id") FROM "posts"
      GROUP BY (("posts"."author_id" + 1) + 5)
    EOSQL
  end

  it 'groups on an association' do
    relation = Post.joins(:author).selecting { id.count }.grouping { author.id }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts"."id") FROM "posts"
      INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      GROUP BY "authors"."id"
    EOSQL
  end

  it 'groups on an aliased association' do
    relation = Post.joining { author.posts }
                   .selecting { author.posts.id.count }
                   .grouping { author.posts.author_id }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts_authors"."id") FROM "posts"
      INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      INNER JOIN "posts" "posts_authors" ON "posts_authors"."author_id" = "authors"."id"
      GROUP BY "posts_authors"."author_id"
    EOSQL
  end
end
