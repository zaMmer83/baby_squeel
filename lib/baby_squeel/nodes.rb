require 'baby_squeel/operators'
require 'baby_squeel/expressions'

module BabySqueel
  module Nodes
    class Attribute < Arel::Attributes::Attribute
      include BabySqueel::Operators
      include BabySqueel::Expressions
    end

    class Function < Arel::Nodes::NamedFunction
      include Arel::Math
      include Arel::OrderPredications
      include BabySqueel::Operators
    end

    class Operation < Arel::Nodes::InfixOperation
      include BabySqueel::Operators
    end

    class Avg < Arel::Nodes::Avg
      include Arel::OrderPredications
    end

    class Count < Arel::Nodes::Count
      include Arel::OrderPredications
    end

    class Extract < Arel::Nodes::Extract
      include Arel::OrderPredications
    end

    class Min < Arel::Nodes::Min
      include Arel::OrderPredications
    end

    class Max < Arel::Nodes::Max
      include Arel::OrderPredications
    end

    class Sum < Arel::Nodes::Sum
      include Arel::OrderPredications
    end
  end
end
