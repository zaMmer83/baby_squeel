# frozen_string_literal: true

RSpec.describe BabySqueel do
  it "has a version number" do
    expect(BabySqueel::VERSION).not_to be nil
  end

  it "does something useful" do
    articles = Article.query do
      select(id, name)
      where(id == 1)
    end

    expect(articles.to_sql).to eq(<<~SQL.squish)
      SELECT "articles"."id", "articles"."name"
      FROM "articles"
      WHERE "articles"."id" = 1
    SQL
  end
end
