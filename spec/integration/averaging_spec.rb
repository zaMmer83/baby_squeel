require 'spec_helper'

describe BabySqueel::ActiveRecord::Calculations, '#averaging' do
  before do
    [Post, Author].each(&:delete_all)
    a1 = Author.create! age: 5
    a2 = Author.create! age: 5
    Post.create! view_count: 2, author: a1
    Post.create! view_count: 4, author: a1
    Post.create! view_count: 6, author: a2
  end

  it 'averages attributes' do
    expect(Post.averaging { view_count }).to eq(4.0)
  end

  it 'averages expressions' do
    expect(Post.averaging { view_count + 2 }).to eq(6.0)
  end

  it 'averages associations' do
    expect(Post.joins(:author).averaging { author.age }).to eq(5)
  end
end
