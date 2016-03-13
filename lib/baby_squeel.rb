require 'active_record'
require 'baby_squeel/version'
require 'baby_squeel/dsl'

module BabySqueel
  module WhereChain
    def has(&block)
      @scope.where_values += DSL.evaluate(@scope, &block)
      @scope
    end
  end

  module QueryMethods
    def selecting(&block)
      select DSL.evaluate(self, &block)
    end

    def ordering(&block)
      order DSL.evaluate(self, &block)
    end
  end
end

ActiveRecord::Base.extend BabySqueel::QueryMethods
ActiveRecord::QueryMethods::WhereChain.prepend BabySqueel::WhereChain
