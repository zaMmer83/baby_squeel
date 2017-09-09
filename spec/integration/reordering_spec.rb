require 'spec_helper'

describe '#reordering' do
  it 'orders using arel' do
    relation = Post.order(title: :desc).reordering do
      title.asc
    end

    expect(relation).to produce_sql(<<-EOSQL)
      SELECT "posts".* FROM "posts"
      ORDER BY "posts"."title" ASC
    EOSQL
  end
end
