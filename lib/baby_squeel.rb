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
end

::ActiveRecord::Base.extend BabySqueel::ActiveRecord::Sifting
::ActiveRecord::Base.extend BabySqueel::ActiveRecord::QueryMethods
::ActiveRecord::Relation.prepend BabySqueel::ActiveRecord::QueryMethods
::ActiveRecord::QueryMethods::WhereChain.prepend BabySqueel::ActiveRecord::WhereChain
