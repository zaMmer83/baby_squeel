module BabySqueel
  module Nodes
    module JoinEquality
      # Allows us to compare Arel join nodes with
      # Active Record association joins.

      def initialize(left, right, association_names)
        super(left, right)
        @association_names = association_names
      end

      def same_association?(other)
        case other
        when self.class.superclass
          left == other.left && right == other.right
        when Symbol, String, Array, Hash
          make_tree(@association_names) == make_tree(other)
        else
          false
        end
      end

      private

      def make_tree(value)
        ::ActiveRecord::Associations::JoinDependency.make_tree(value)
      end
    end
  end
end
