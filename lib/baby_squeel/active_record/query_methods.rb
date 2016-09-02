require 'baby_squeel/dsl'
require 'baby_squeel/active_record/joins_values'

module BabySqueel
  module ActiveRecord
    module QueryMethods
      # Constructs Arel for ActiveRecord::Base#joins using the DSL.
      def joining(&block)
        exprs, binds = DSL.evaluate_joins(self, &block)
        spawn.joining! exprs, binds
      end

      def joining!(exprs, binds = [])
        unless joins_values.kind_of? JoinsValues
          self.joins_values = JoinsValues.new(joins_values)
        end

        self.joins_values += exprs
        self.bind_values += binds
        self
      end

      # Constructs Arel for ActiveRecord::Base#select using the DSL.
      def selecting(&block)
        select DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::Base#order using the DSL.
      def ordering(&block)
        order DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::Base#group using the DSL.
      def grouping(&block)
        group DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::Base#having using the DSL.
      def when_having(&block)
        having DSL.evaluate(self, &block)
      end
    end
  end
end
