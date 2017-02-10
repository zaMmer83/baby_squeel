module BabySqueel
  module ActiveRecord
    module Calculations
      def plucking(&block)
        pluck DSL.evaluate_calculation(self, &block)
      end

      def counting(&block)
        count DSL.evaluate_calculation(self, &block)
      end

      def summing(&block)
        sum DSL.evaluate_calculation(self, &block)
      end

      def averaging(&block)
        average DSL.evaluate_calculation(self, &block)
      end

      def minimizing(&block)
        minimum DSL.evaluate_calculation(self, &block)
      end

      def maximizing(&block)
        maximum DSL.evaluate_calculation(self, &block)
      end

      # ActiveRecord 4.2 needs a little monkey patching.
      if ::ActiveRecord::VERSION::MAJOR < 5
        # They're going to try to call #type_cast_from_database
        # on whatever I return here.
        def type_for(field)
          if field.kind_of? CalculationProxy
            field
          else
            super
          end
        end

        def aggregate_column(column_name)
          if column_name.kind_of? CalculationProxy
            column_name.unwrap
          else
            super
          end
        end
      end
    end
  end
end
