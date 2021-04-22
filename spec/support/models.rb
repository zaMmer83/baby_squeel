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
