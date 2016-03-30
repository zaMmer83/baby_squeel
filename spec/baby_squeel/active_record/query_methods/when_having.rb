require 'spec_helper'

describe BabySqueel::ActiveRecord::QueryMethods, '#when_having' do
  def having_sql(expr)
    if ActiveRecord::VERSION::MAJOR > 4
      "HAVING (#{expr})" # AR5 wraps with parenthesis
    else
      "HAVING #{expr}"
    end
  end

  it 'adds a having clause' do
    relation = Post.selecting { id.count }
                   .grouping { author_id }
                   .when_having { id.count > 5 }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts"."id") FROM "posts"
      GROUP BY "posts"."author_id"
      #{having_sql 'COUNT("posts"."id") > 5'}
    EOSQL
  end

  it 'adds a having clause with a calculation' do
    relation = Post.selecting { id.count }
                   .grouping { (author_id + 5 ) * 3 }
                   .when_having { id.count > 5 }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts"."id") FROM "posts"
      GROUP BY ("posts"."author_id" + 5) * 3
      #{having_sql 'COUNT("posts"."id") > 5'}
    EOSQL
  end

  it 'adds a having clause with an association' do
    relation = Post.selecting { id.count }
                   .joins(:author)
                   .grouping { author.id }
                   .when_having { author.id.count > 5 }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts"."id") FROM "posts"
      INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      GROUP BY "authors"."id"
      #{having_sql 'COUNT("authors"."id") > 5'}
    EOSQL
  end

  it 'adds a having clause with an aliased table' do
    relation = Post.selecting { author.posts.id.count }
                   .joining { author.posts }
                   .grouping { author.posts.id }
                   .when_having { author.posts.id.count > 5 }

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT COUNT("posts_authors"."id") FROM "posts"
      INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"
      INNER JOIN "posts" "posts_authors" ON "posts_authors"."author_id" = "authors"."id"
      GROUP BY "posts_authors"."id"
      #{having_sql 'COUNT("posts_authors"."id") > 5'}
    EOSQL
  end
end
