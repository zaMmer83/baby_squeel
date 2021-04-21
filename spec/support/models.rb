class ApplicationRecord < ActiveRecord::Base
  extend BabySqueel::Model

  self.abstract_class = true
end

class Article < ApplicationRecord
end
