require 'spec_helper'

describe BabySqueel::ActiveRecord::Calculations, '#maximizing' do
  before do
    [Post, Author].each(&:delete_all)
    a1 = Author.create! age: 1
    a2 = Author.create! age: 5
    Post.create! view_count: 2, author: a1
    Post.create! view_count: 6, author: a2
  end

  it 'maximizes attributes' do
    expect(Post.maximizing { view_count }).to eq(6)
  end

  it 'maximizes expressions' do
    expect(Post.maximizing { view_count + 2 }).to eq(8)
  end

  it 'maximizes associations' do
    expect(Post.joins(:author).maximizing { author.age }).to eq(5)
  end
end
