require 'spec_helper'

describe BabySqueel::ActiveRecord::Calculations, '#minimizing' do
  before do
    [Post, Author].each(&:delete_all)
    a1 = Author.create! age: 1
    a2 = Author.create! age: 5
    Post.create! view_count: 2, author: a1
    Post.create! view_count: 6, author: a2
  end

  it 'minimizes attributes' do
    expect(Post.minimizing { view_count }).to eq(2)
  end

  it 'minimizes expressions' do
    expect(Post.minimizing { view_count + 2 }).to eq(4)
  end

  it 'minimizes associations' do
    expect(Post.joins(:author).minimizing { author.age }).to eq(1)
  end
end
