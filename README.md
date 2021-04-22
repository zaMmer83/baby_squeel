# BabySqueel

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/baby_squeel`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'baby_squeel'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install baby_squeel

## Example

Your models look like this:

```ruby
class ApplicationRecord < ActiveRecord::Base
  extend BabySqueel::Extension
  self.abstract_class = true
end

class User < ApplicationRecord
  has_many :comments
  has_many :recipes
end

class Recipe < ApplicationRecord
  belongs_to :user
  has_many :comments
end

class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
end
```

#### Joins

```ruby
User.query do
  comments = assoc :comments, :c
  recipes = comments.assoc :recipe, :r

  select id, name
  join comments
  left_join recipes
  where recipes.name == "Pasta"
  where comments.body =~ "%delicious%"
end
```

```sql
SELECT "users"."id", "users"."name"
FROM "users"
INNER JOIN "comments" "c" ON "c"."user_id" = "users"."id"
LEFT OUTER JOIN "recipes" "r" ON "r"."id" = "c"."recipe_id"
WHERE "r"."name" = 'Pasta'
AND "c"."body" LIKE '%delicious%'
```

#### Aggregation

```ruby
Recipe.query do
  select user_id, sql.count(id)
  where id > 2
  where_not id > 20
  group_by user_id
  having sql.count(id) > 3
  order_by user_id.desc
end
```

```sql
SELECT "recipes"."user_id", COUNT("recipes"."id")
FROM "recipes"
WHERE "recipes"."id" > 2
AND "recipes"."id" <= 20
GROUP BY "recipes"."user_id"
HAVING COUNT("recipes"."id") > 3
ORDER BY "recipes"."user_id" DESC
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/baby_squeel.
