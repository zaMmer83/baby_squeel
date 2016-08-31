require 'baby_squeel/dsl'

module BabySqueel
  module ActiveRecord
    module Sifting
      def sifter(name, &block)
        define_singleton_method "sift_#{name}" do |*args|
          DSL.evaluate_sifter(self, *args, &block)
        end
      end
    end

    module QueryMethods
      # Constructs Arel for ActiveRecord::Base#joins using the DSL.
      def joining(&block)
        arel, binds = DSL.evaluate_joins(self, &block)
        joins(arel).tap { |s| s.bind_values += binds }
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

    module WhereChain
      # Constructs Arel for ActiveRecord::Base#where using the DSL.
      def has(&block)
        @scope.where! DSL.evaluate(@scope, &block)
        @scope
      end
    end
  end
end
