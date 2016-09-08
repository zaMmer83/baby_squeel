require 'baby_squeel/join_dependency/builder'
require 'baby_squeel/join_dependency/finder'

module BabySqueel
  # This is the thing that gets added to Active Record's joins_values.
  # By including Polyamorous::TreeNode, when this instance is found when
  # traversing joins in ActiveRecord::Associations::JoinDependency::walk_tree,
  # JoinExpression#add_to_tree will be called.
  class JoinExpression
    include Polyamorous::TreeNode

    attr_reader :associations

    def initialize(associations)
      @associations = associations
    end

    def add_to_tree(hash)
      @associations.inject(hash) do |acc, assoc|
        assoc.add_to_tree(acc)
      end
    end
  end
end
