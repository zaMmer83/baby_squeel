require 'spec_helper'

describe BabySqueel::ActiveRecord::Calculations, '#counting' do
  before do
    [Post, Author].each(&:delete_all)
    author1 = Author.create!
    Post.create! title: 'Foo', author: author1
    Post.create! title: 'Foo'
  end

  it 'counts' do
    expect(Post.counting { title }).to eq(2)
  end

  it 'counts distinct' do
    expect(Post.distinct.counting { title }).to eq(1)
  end

  it 'counts association' do
    expect(Post.joins(:author).counting { author.id }).to eq(1)
  end

  it 'counts with limit' do
    expect(Post.limit(1).counting { id }).to eq(1)
  end
end
