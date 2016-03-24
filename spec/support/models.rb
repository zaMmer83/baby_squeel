class Author < ActiveRecord::Base
  has_many :posts
  has_many :comments
end

class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :author
  has_many :author_comments, through: :author, source: :comments
end

class Comment < ActiveRecord::Base
  belongs_to :author
  belongs_to :post
end
