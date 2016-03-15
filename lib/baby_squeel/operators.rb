module BabySqueel
  module Operators
    module ArelAliasing
      def arel_alias(operator, arel_name)
        define_method operator do |other|
          send(arel_name, other)
        end
      end
    end

    module Comparison
      extend ArelAliasing
      arel_alias :<, :lt
      arel_alias :>, :gt
      arel_alias :<=, :lteq
      arel_alias :>=, :gteq
    end

    module Equality
      extend ArelAliasing
      arel_alias :==, :eq
      arel_alias :'!=', :not_eq
    end

    module Generic
      def op(operator, other)
        Nodes.wrap Arel::Nodes::InfixOperation.new(operator, self, other)
      end
    end

    module Grouping
      extend ArelAliasing
      arel_alias :&, :and
      arel_alias :|, :or
    end

    module Matching
      extend ArelAliasing
      arel_alias :=~, :matches
      arel_alias :'!~', :does_not_match
    end
  end
end
