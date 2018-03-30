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
        table = find_join_association(associations).table
        reconstruct_with_type_caster(table, associations)
      end

      private

      def find_join_association(associations)
        associations.inject(join_dependency.send(:join_root)) do |parent, assoc|
          parent.children.find do |join_association|
            reflections_equal?(
              assoc._reflection,
              join_association.reflection
            )
          end
        end
      end

      # Compare two reflections and see if they're the same.
      def reflections_equal?(a, b)
        comparable_reflection(a) == comparable_reflection(b)
      end

      # Get the parent of the reflection if it has one.
      # In AR4, #parent_reflection returns [name, reflection]
      # In AR5, #parent_reflection returns just a reflection
      def comparable_reflection(reflection)
        [*reflection.parent_reflection].last || reflection
      end

      # Active Record 5's AliasTracker initializes Arel tables
      # with the type_caster belonging to the wrong model.
      #
      # See: https://github.com/rails/rails/pull/27994
      def reconstruct_with_type_caster(table, associations)
        return table if ::ActiveRecord::VERSION::MAJOR < 5
        type_caster = associations.last._scope.type_caster
        ::Arel::Table.new(table.name, type_caster: type_caster)
      end
    end
  end
end
