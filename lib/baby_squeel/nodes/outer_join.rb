require 'baby_squeel/nodes/join_equality'

module BabySqueel
  module Nodes
    class OuterJoin < Arel::Nodes::OuterJoin
      include JoinEquality
    end
  end
end
