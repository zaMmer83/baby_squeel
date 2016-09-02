module BabySqueel
  module JoinDependency
    class Builder # :nodoc:
      attr_reader :relation

      def initialize(relation)
        @relation = relation
      end

      def add_associations(*names)
        buckets[:association_join] ||= []
        buckets[:association_join] += names.reject { |name|
          already_joined?(name)
        }
      end

      def to_join_dependency
        ::ActiveRecord::Associations::JoinDependency.new(
          relation.model,
          association_joins,
          join_list
        )
      end

      private

      def already_joined?(name)
        join_nodes.any? do |node|
          node.respond_to?(:same_association?) &&
            node.same_association?(name)
        end
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
        @buckets ||= relation.joins_values.flatten.group_by do |join|
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
