require 'active_record'
require 'active_record/relation'
require 'baby_squeel/version'
require 'baby_squeel/errors'
require 'baby_squeel/active_record'

module BabySqueel
  class << self
    def configure
      yield self
    end

    def enable_compatibility!
      require 'baby_squeel/compat'
      BabySqueel::Compat.enable!
    end

    def [](thing)
      if thing.respond_to?(:model_name)
        Relation.new(thing)
      else
        Table.new(Arel::Table.new(thing))
      end
    end
  end
end

::ActiveRecord::Base.extend BabySqueel::ActiveRecord::Sifting
::ActiveRecord::Base.extend BabySqueel::ActiveRecord::QueryMethods
::ActiveRecord::Relation.prepend BabySqueel::ActiveRecord::QueryMethods
::ActiveRecord::QueryMethods::WhereChain.prepend BabySqueel::ActiveRecord::WhereChain
