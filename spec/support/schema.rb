ActiveRecord::Schema.define do
  create_table :authors, force: true do |t|
    t.string :name
  end

  create_table :posts, force: true do |t|
    t.string :title
    t.belongs_to :author
    t.datetime :published_at
  end

  create_table :comments, force: true do |t|
    t.string :body
    t.belongs_to :post
    t.belongs_to :author
  end
end
