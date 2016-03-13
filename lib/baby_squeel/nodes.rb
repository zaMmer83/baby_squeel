require 'baby_squeel/operators'

module BabySqueel
  module Nodes
    class Attribute < Arel::Attributes::Attribute
      include BabySqueel::Operators
    end

    class Function < Arel::Nodes::NamedFunction
      include Arel::OrderPredications
      include BabySqueel::Operators
    end

    class Operation < Arel::Nodes::InfixOperation
      include BabySqueel::Operators
    end
  end
end
