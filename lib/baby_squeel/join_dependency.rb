require 'join_dependency'

module BabySqueel
  module JoinDependency
    # This class allows BabySqueel to slip custom
    # joins_values into Active Record's JoinDependency
    class Injector < Array # :nodoc:
      # Active Record will call group_by on this object
      # in ActiveRecord::QueryMethods#build_joins. This
      # allows BabySqueel::Joins to be treated
      # like typical join hashes until Polyamorous can
      # deal with them.
      def group_by
        super do |join|
          case join
          when BabySqueel::Join
            :association_join
          else
            yield join
          end
        end
      end
    end

    class Builder # :nodoc:
      attr_reader :join_dependency

      def initialize(relation)
        @join_dependency = ::JoinDependency.from_relation(relation) do |join|
          :association_join if join.kind_of? BabySqueel::Join
        end
      end

      # Find the alias of a BabySqueel::Association, by passing
      # a list (in order of chaining) of associations and finding
      # the respective JoinAssociation at each level.
      def find_alias(associations)
        # If we tell join_dependency to construct its tables, Active Record
        # handles building the correct aliases and attaching them to its
        # JoinDepenencies.
        join_dependency.send(:construct_tables!, join_dependency.send(:join_root))
        join_association = find_join_association(associations)

        join_association.table
      end

      private

      def find_join_association(associations)
        join_root = join_dependency.send(:join_root)
        steps = associations.map {|a| a._reflection.name}
        association_from_steps(join_root, steps)
      end

      # Search depth-first through the descendants of +current+ for successive
      # associations in +steps+.
      #
      # Each generation of descent consumes one element of +steps+.
      def association_from_steps(current, steps)
        return current if steps.empty?
        matching_assoc = nil
        current.children.each do |child|
          next unless child.reflection.name == steps.first
          matching_assoc = association_from_steps(child, steps[1..-1])
          break if matching_assoc
        end
        matching_assoc
      end
    end
  end
end
