# BabySqueel

[![Build Status](https://travis-ci.org/rzane/baby_squeel.svg?branch=master)](https://travis-ci.org/rzane/baby_squeel)
[![Code Climate](https://codeclimate.com/github/rzane/baby_squeel/badges/gpa.svg)](https://codeclimate.com/github/rzane/baby_squeel)
[![Coverage Status](https://coveralls.io/repos/github/rzane/baby_squeel/badge.svg?branch=master)](https://coveralls.io/github/rzane/baby_squeel?branch=master)

Ever used the squeel gem? It was a really nice way to build complex queries. However, squeel monkeypatches ActiveRecord internals, so it has a tendency to break every time a new ActiveRecord version comes out.

For me, that's a deal breaker. BabySqueel provides a *zero monkeypatch* query DSL for ActiveRecord.

It's also suprisingly uncomplicated. It's really just a layer of sugar on top of Arel.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'baby_squeel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install baby_squeel

## Usage

Okay, so we have a `Post` model:

```ruby
class Post < ActiveRecord::Base
  belongs_to :author
end
```

#### Selects

```ruby
Post.selecting { (id + 5).as('id_plus_five') }
# SELECT "posts"."id" + 5 AS id_plus_five FROM "posts"

Post.selecting { id.sum }
# SELECT SUM("posts"."id") FROM "posts"

Post.joins(:author).selecting { [id, author.id] }
# SELECT "posts"."id", "author"."id"
# FROM "posts"
# INNER JOIN "authors" ON "posts"."author_id" = "authors"."id"
```

#### Wheres

```ruby
Post.where.has { title == 'My Post' }
# SELECT "posts".* FROM "posts" WHERE "posts"."title" = 'My Post'

Post.where.has { (id > 0).and(id < 500) }
# SELECT "posts".* FROM "posts" WHERE "posts"."id" > 0

Post.where.has { title =~ 'My P%' }
# SELECT "posts".* FROM "posts" WHERE "posts"."title" LIKE 'My P%'
```

#### Orders

```ruby
Post.ordering { [id.desc, title.asc] }
# SELECT "posts".* FROM "posts" ORDER BY "posts"."id" DESC, "posts"."title" ASC

Post.ordering { (id * 5).desc }
# SELECT "posts".* FROM "posts" ORDER BY "posts"."id" * 5 DESC

Post.select(:author_id).group(:author_id).ordering { id.count }
# SELECT "posts"."author_id"
# FROM "posts" GROUP BY "posts"."author_id"
# ORDER BY COUNT("posts"."id")
```

#### Functions

You can even use SQL functions!

```ruby
Post.selecting { coalesce(author_id, 5).as('author_id_with_default') }
# SELECT coalesce("posts"."author_id", 5) AS author_id_with_default FROM "posts"
```

## Important Notes

While inside one of BabySqueel's blocks, `self` will be something totally different. You won't have access to your instance variables or methods.

Don't worry, there's an easy solution. Just give arity to the block:

```ruby
Post.where.has { |table| table.title == 'Test' }
# SELECT "posts".* WHERE "posts"."title" = 'Test'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rzane/baby_squeel.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
