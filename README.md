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

## Usage

```ruby
class ApplicationRecord < ActiveRecord::Base
  extend BabySqueel::Extension
  self.abstract_class = true
end

class User < ApplicationRecord
  has_many :articles
end

class Article < ApplicationRecord
  belongs_to :user
  has_many :comments
end

class Comment < ApplicationRecord
  belongs_to :article
end

User.query do
  comments = assoc :comments, :c
  recipes = comments.assoc :recipes, :r

  select id, name
  join comments
  join recipes
  where recipes.title == "Pasta"
  where comments.body =~ "%delicious%"
end
# SELECT "users"."id", "users"."name"
# INNER JOIN "recipes" "r" ON "r"."user_id" = "users"."id"
# INNER JOIN "comments" "c" ON "c"."recipe_id" = "r"."id"
# WHERE "r"."title" = "Pasta"
# AND "c"."body" LIKE "%delicious%"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/baby_squeel.
