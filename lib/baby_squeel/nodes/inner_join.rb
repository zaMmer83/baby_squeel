require 'baby_squeel/nodes/join_equality'

module BabySqueel
  module Nodes
    class InnerJoin < Arel::Nodes::InnerJoin
      include JoinEquality

      def eql?(other)
        super || same_association?(other)
      end
    end
  end
end
