require 'baby_squeel/dsl'

module BabySqueel
  module ActiveRecord
    module QueryMethods
      # Constructs Arel for ActiveRecord::Base#joins using the DSL.
      def joining(&block)
        joins DSL.evaluate(self, &block)
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
