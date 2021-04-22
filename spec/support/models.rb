class ApplicationRecord < ActiveRecord::Base
  extend BabySqueel::Extension

  self.abstract_class = true
end

class User < ApplicationRecord
  has_many :articles
end

class Article < ApplicationRecord
  belongs_to :user
end
