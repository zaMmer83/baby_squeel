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

    def [](thing, **kwargs)
      if thing.respond_to?(:model_name)
        Relation.new(thing)
      elsif thing.kind_of?(Arel::Table)
        Table.new(thing)
      else
        Table.new(Arel::Table.new(thing, **kwargs))
      end
    end
  end
end

ActiveSupport.on_load :active_record do
  ::ActiveRecord::Base.extend BabySqueel::ActiveRecord::Base
  ::ActiveRecord::Relation.prepend BabySqueel::ActiveRecord::QueryMethods
  ::ActiveRecord::QueryMethods::WhereChain.prepend BabySqueel::ActiveRecord::WhereChain
end
