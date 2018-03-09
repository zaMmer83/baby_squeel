require 'spec_helper'

describe '#reordering' do
  it 'orders using arel' do
    relation = Post.order(title: :desc).reordering do
      title.asc
    end

    expect(relation).to match_sql_snapshot
  end
end
