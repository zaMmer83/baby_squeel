ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end

  create_table :recipes do |t|
    t.string :name
    t.belongs_to :user
  end

  create_table :comments do |t|
    t.string :body
    t.belongs_to :user
    t.belongs_to :recipe
  end
end
