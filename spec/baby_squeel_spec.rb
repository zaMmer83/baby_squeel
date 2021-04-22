# frozen_string_literal: true

RSpec.describe BabySqueel do
  it "has a version number" do
    expect(BabySqueel::VERSION).not_to be nil
  end

  it "does something useful" do
    recipes = Recipe.query do
      select id, name
      where id == 1
    end

    expect(recipes.to_sql).to eq(<<~SQL.squish)
      SELECT "recipes"."id", "recipes"."name"
      FROM "recipes"
      WHERE "recipes"."id" = 1
    SQL
  end

  it "joins an association" do
    recipes = Recipe.query do
      join assoc(:user)
    end

    expect(recipes.to_sql).to eq(<<~SQL.squish)
      SELECT "recipes".*
      FROM "recipes"
      INNER JOIN "users" ON "users"."id" = "recipes"."user_id"
    SQL
  end

  it "joins an aliased association" do
    recipes = Recipe.query do
      join assoc(:user, :u)
    end

    expect(recipes.to_sql).to eq(<<~SQL.squish)
      SELECT "recipes".*
      FROM "recipes"
      INNER JOIN "users" "u" ON "u"."id" = "recipes"."user_id"
    SQL
  end

  it "left joins an association" do
    recipes = Recipe.query do
      left_join assoc(:user)
    end

    expect(recipes.to_sql).to eq(<<~SQL.squish)
      SELECT "recipes".*
      FROM "recipes"
      LEFT OUTER JOIN "users" ON "users"."id" = "recipes"."user_id"
    SQL
  end

  it "left joins an aliased association" do
    recipes = Recipe.query do
      left_join assoc(:user, :u)
    end

    expect(recipes.to_sql).to eq(<<~SQL.squish)
      SELECT "recipes".*
      FROM "recipes"
      LEFT OUTER JOIN "users" "u" ON "u"."id" = "recipes"."user_id"
    SQL
  end

  it "complex join" do
    recipes = Recipe.query do
      u = assoc(:user, :u)
      r = u.assoc(:recipes, :r)

      select id, u.id, r.id
      join u
      left_join r
      where r.id == 1
    end

    expect(recipes.to_sql).to eq(<<~SQL.squish)
      SELECT "recipes"."id", "u"."id", "r"."id"
      FROM "recipes"
      INNER JOIN "users" "u" ON "u"."id" = "recipes"."user_id"
      LEFT OUTER JOIN "recipes" "r" ON "r"."user_id" = "u"."id"
      WHERE "r"."id" = 1
    SQL
  end

  it "aggregates" do
    recipes = Recipe.query do
      select user_id, sql.count(id)
      where id > 2
      where_not id > 20
      group_by user_id
      having sql.count(id) > 3
      order_by user_id.desc
    end

    expect(recipes.to_sql).to eq(<<~SQL.squish)
      SELECT "recipes"."user_id", COUNT("recipes"."id")
      FROM "recipes"
      WHERE "recipes"."id" > 2
      AND "recipes"."id" <= 20
      GROUP BY "recipes"."user_id"
      HAVING COUNT("recipes"."id") > 3
      ORDER BY "recipes"."user_id" DESC
    SQL
  end
end
