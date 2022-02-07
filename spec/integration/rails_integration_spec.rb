require 'spec_helper'

describe 'test that plain rails still works' do
  it 'joins and merge' do
    unless BabySqueel::ActiveRecord::VersionHelper.at_least_5_2_3?
      pending 'Rails does a LEFT OUTER JOIN for comments in the 5.2.0 version but an INNER JOIN in 5.2.3 +'
    end

    relation = Author.joins(:posts).merge(Post.joins(:comments).merge(Comment.where(body: 'body')))

    expect(relation).to match_sql_snapshot
  end

  it 'left_joins' do
    relation = Post.left_joins(:parent, :author)

    expect(relation).to match_sql_snapshot
  end
end
