require 'active_record'
require 'active_record/relation'
require 'baby_squeel/version'
require 'baby_squeel/active_record'

module BabySqueel
  def self.configure
    yield self
  end

  def self.enable_compatibility!
    require 'baby_squeel/compat'
    BabySqueel::Compat.enable!
  end

  class NotFoundError < StandardError
    def initialize(model_name, name)
      super "There is no column or association named '#{name}' for #{model_name}."
    end
  end

  class AssociationNotFoundError < StandardError
    def initialize(model_name, name)
      super "Association named '#{name}' was not found for #{model_name}."
    end
  end
end

::ActiveRecord::Base.extend BabySqueel::ActiveRecord::Sifting
::ActiveRecord::Base.extend BabySqueel::ActiveRecord::QueryMethods
::ActiveRecord::Relation.prepend BabySqueel::ActiveRecord::QueryMethods
::ActiveRecord::QueryMethods::WhereChain.prepend BabySqueel::ActiveRecord::WhereChain
