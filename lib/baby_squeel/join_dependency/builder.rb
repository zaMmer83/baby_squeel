require 'baby_squeel/join_dependency/injector'

module BabySqueel
  module JoinDependency
    # Unfortunately, this is mostly all duplication of
    # ActiveRecord::QueryMethods#build_joins
    class Builder # :nodoc:
      attr_reader :relation

      def initialize(relation)
        @relation = relation
        @joins_values = relation.joins_values.dup
      end

      def ensure_associated(*values)
        @joins_values += values
      end

      def join_dependency
        ::ActiveRecord::Associations::JoinDependency.new(
          relation.model,
          association_joins,
          join_list
        )
      end
      delegate :join_root, to: :join_dependency

      def find_join_association(associations)
        associations.inject(join_root) do |parent, assoc|
          parent.children.find do |join_association|
            reflections_equal?(
              assoc._reflection,
              join_association.reflection
            )
          end
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

      def join_list
        join_nodes + join_strings_as_ast
      end

      def association_joins
        buckets[:association_join] || []
      end

      def stashed_association_joins
        buckets[:stashed_join] || []
      end

      def join_nodes
        (buckets[:join_node] || []).uniq
      end

      def string_joins
        (buckets[:string_join] || []).map(&:strip).uniq
      end

      if Arel::VERSION >= '7.0.0'
        def join_strings_as_ast
          manager = Arel::SelectManager.new(relation.table)
          relation.send(:convert_join_strings_to_ast, manager, string_joins)
        end
      else
        def join_strings_as_ast
          manager = Arel::SelectManager.new(relation.table.engine, relation.table)
          relation.send(:custom_join_ast, manager, string_joins)
        end
      end

      def buckets
        @buckets ||= Injector.new(@joins_values).group_by do |join|
          case join
          when String
            :string_join
          when Hash, Symbol, Array
            :association_join
          when ::ActiveRecord::Associations::JoinDependency
            :stashed_join
          when ::Arel::Nodes::Join
            :join_node
          else
            raise 'unknown class: %s' % join.class.name
          end
        end
      end
    end
  end
end
