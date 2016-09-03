require 'baby_squeel/nodes/join_equality'

module BabySqueel
  module Nodes
    class OuterJoin < Arel::Nodes::OuterJoin
      include JoinEquality

      def eql?(other)
        case other
        when Arel::Nodes::OuterJoin
          left.eql?(other.left) && right.eql?(other.right)
        else
          super
        end
      end
    end
  end
end
