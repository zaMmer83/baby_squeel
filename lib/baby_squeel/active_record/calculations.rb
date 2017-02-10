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
    end
  end
end
