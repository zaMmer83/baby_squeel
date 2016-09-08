require 'active_support/core_ext/hash/indifferent_access'

module BabySqueel
  module JoinDependency
    # This is the thing that gets added to Active Record's joins_values.
    # By including Polyamorous::TreeNode, when this instance is found when
    # traversing joins in ActiveRecord::Associations::JoinDependency::walk_tree,
    # JoinPath#add_to_tree will be called.
    class JoinPath
      include Polyamorous::TreeNode

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
end
