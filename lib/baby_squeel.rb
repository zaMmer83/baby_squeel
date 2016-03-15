require 'active_record'
require 'active_record/relation'
require 'baby_squeel/version'
require 'baby_squeel/active_record'

module BabySqueel
end

::ActiveRecord::Base.extend BabySqueel::ActiveRecord::QueryMethods
::ActiveRecord::QueryMethods::WhereChain.prepend BabySqueel::ActiveRecord::WhereChain
