require 'spec_helper'

describe BabySqueel::ActiveRecord::QueryMethods, '#having_grouped' do
  it 'adds a having clause' do
    relation = Post.selecting { id.count }
                   .grouping { author_id }
                   .having_grouped { id.count > 5 }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts"."id") FROM "posts"
      GROUP BY "posts"."author_id"
      HAVING (COUNT("posts"."id") > 5)
    EOSQL
  end

  it 'adds a having clause with a calculation' do
    relation = Post.selecting { id.count }
                   .grouping { (author_id + 5 ) * 3 }
                   .having_grouped { id.count > 5 }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts"."id") FROM "posts"
      GROUP BY ("posts"."author_id" + 5) * 3
      HAVING (COUNT("posts"."id") > 5)
    EOSQL
  end

  it 'adds a having clause with an association' do
    relation = Post.selecting { id.count }
                   .joins(:author)
                   .grouping { author.id }
                   .having_grouped { author.id.count > 5 }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts"."id") FROM "posts"
      INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      GROUP BY "authors"."id"
      HAVING (COUNT("authors"."id") > 5)
    EOSQL
  end

  it 'adds a having clause with an aliased table' do
    relation = Post.selecting { author.posts.id.count }
                   .joining { author.posts }
                   .grouping { author.posts.id }
                   .having_grouped { author.posts.id.count > 5 }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts_authors"."id") FROM "posts"
      INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      INNER JOIN "posts" "posts_authors" ON "posts_authors"."author_id" = "authors"."id"
      GROUP BY "posts_authors"."id"
      HAVING (COUNT("posts_authors"."id") > 5)
    EOSQL
  end
end
