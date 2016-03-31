class Author < ActiveRecord::Base
  has_many :posts
  has_many :comments
end

class UglyAuthor < Author
  default_scope { where ugly: true }
end

class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :author
  has_many :author_comments, through: :author, source: :comments

  belongs_to :ugly_author, foreign_key: :author_id
  has_many :ugly_author_comments, through: :ugly_author, source: :comments
end

class Comment < ActiveRecord::Base
  belongs_to :author
  belongs_to :post
end
