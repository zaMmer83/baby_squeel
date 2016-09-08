require 'active_support/core_ext/hash/indifferent_access'

module BabySqueel
  module JoinDependency
    # Pretends to be a hash to trick Active Record in
    # ActiveRecord::QueryMethods#build_joins. Instances
    # of this class will be passed into JoinDependency
    # as associations. This sort of inheritance is gross,
    # but in this case, it's way better than duplicating.
    class JoinPath < Hash
      include Polyamorous::TreeNode

      def initialize(associations)
        super()
        @associations = associations
      end

      def add_to_tree(hash)
        walk_through_path(@associations.dup, hash)
      end

      private

      def walk_through_path(path, hash)
        cache = path.shift.add_to_tree(hash)
        path.empty? ? cache : walk_through_path(path, cache)
      end
    end
  end
end
