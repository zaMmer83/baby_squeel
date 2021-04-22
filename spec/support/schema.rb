ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users

  create_table :recipes do |t|
    t.string :name
    t.belongs_to :user
  end
end
