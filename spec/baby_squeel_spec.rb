# frozen_string_literal: true

RSpec.describe BabySqueel do
  it "has a version number" do
    expect(BabySqueel::VERSION).not_to be nil
  end

  it "does something useful" do
    articles = Article.query do
      select id, name
      where id == 1
    end

    expect(articles.to_sql).to eq(<<~SQL.squish)
      SELECT "articles"."id", "articles"."name"
      FROM "articles"
      WHERE "articles"."id" = 1
    SQL
  end

  it "joins an association" do
    articles = Article.query do
      join assoc(:user)
    end

    expect(articles.to_sql).to eq(<<~SQL.squish)
      SELECT "articles".*
      FROM "articles"
      INNER JOIN "users" ON "users"."id" = "articles"."user_id"
    SQL
  end

  it "joins an aliased association" do
    articles = Article.query do
      join assoc(:user, :u)
    end

    expect(articles.to_sql).to eq(<<~SQL.squish)
      SELECT "articles".*
      FROM "articles"
      INNER JOIN "users" "u" ON "u"."id" = "articles"."user_id"
    SQL
  end

  it "left joins an association" do
    articles = Article.query do
      left_join assoc(:user)
    end

    expect(articles.to_sql).to eq(<<~SQL.squish)
      SELECT "articles".*
      FROM "articles"
      LEFT OUTER JOIN "users" ON "users"."id" = "articles"."user_id"
    SQL
  end

  it "left joins an aliased association" do
    articles = Article.query do
      left_join assoc(:user, :u)
    end

    expect(articles.to_sql).to eq(<<~SQL.squish)
      SELECT "articles".*
      FROM "articles"
      LEFT OUTER JOIN "users" "u" ON "u"."id" = "articles"."user_id"
    SQL
  end

  it "complex join" do
    articles = Article.query do
      u = assoc(:user, :u)
      a = u.assoc(:articles, :a)

      select id, u.id, a.id
      join u
      left_join a
      where a.id == 1
    end

    expect(articles.to_sql).to eq(<<~SQL.squish)
      SELECT "articles"."id", "u"."id", "a"."id"
      FROM "articles"
      INNER JOIN "users" "u" ON "u"."id" = "articles"."user_id"
      LEFT OUTER JOIN "articles" "a" ON "a"."user_id" = "u"."id"
      WHERE "a"."id" = 1
    SQL
  end

  it "aggregates" do
    articles = Article.query do
      select user_id, sql.count(id)
      where id > 2
      where_not id > 20
      group_by user_id
      having sql.count(id) > 3
      order_by user_id.desc
    end

    expect(articles.to_sql).to eq(<<~SQL.squish)
      SELECT "articles"."user_id", COUNT("articles"."id")
      FROM "articles"
      WHERE "articles"."id" > 2
      AND "articles"."id" <= 20
      GROUP BY "articles"."user_id"
      HAVING COUNT("articles"."id") > 3
      ORDER BY "articles"."user_id" DESC
    SQL
  end
end
