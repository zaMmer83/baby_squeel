require 'baby_squeel/dsl'

module BabySqueel
  module ActiveRecord
    module QueryMethods
      def selecting(&block)
        select DSL.evaluate(self, &block)
      end

      def ordering(&block)
        order DSL.evaluate(self, &block)
      end
    end

    module WhereChain
      if ::ActiveRecord::VERSION::MAJOR > 4
        def has(&block)
          opts = DSL.evaluate(@scope, &block)
          factory = @scope.send(:where_clause_factory)
          @scope.where_clause += factory.build(opts, [])
          @scope
        end
      else
        def has(&block)
          @scope.where_values += [DSL.evaluate(@scope, &block)]
          @scope
        end
      end
    end
  end
end
