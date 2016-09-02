require 'baby_squeel/dsl'

module BabySqueel
  module ActiveRecord
    module WhereChain
      # Constructs Arel for ActiveRecord::Base#where using the DSL.
      def has(&block)
        @scope.where! DSL.evaluate(@scope, &block)
        @scope
      end
    end
  end
end
