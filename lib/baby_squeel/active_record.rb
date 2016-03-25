require 'baby_squeel/dsl'

module BabySqueel
  module ActiveRecord
    module QueryMethods
      # Constructs Arel for ActiveRecord::Base#joins using the DSL.
      def joining(&block)
        joins DSL.evaluate(unscoped, &block)
      end

      # Constructs Arel for ActiveRecord::Base#select using the DSL.
      def selecting(&block)
        select DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::Base#order using the DSL.
      def ordering(&block)
        order DSL.evaluate(self, &block)
      end
    end

    module WhereChain
      if ::ActiveRecord::VERSION::MAJOR > 4
        # Constructs Arel for ActiveRecord::Base#where using the DSL.
        def has(&block)
          opts = DSL.evaluate(@scope, &block)
          factory = @scope.send(:where_clause_factory)
          @scope.where_clause += factory.build(opts, [])
          @scope
        end
      else
        # Constructs Arel for ActiveRecord::Base#where using the DSL.
        def has(&block)
          @scope.where_values += [DSL.evaluate(@scope, &block)]
          @scope
        end
      end
    end
  end
end
