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
        @join_dependency = from_relation(relation) do |join|
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
        if ::ActiveRecord::VERSION::STRING >= '5.2.3'
          join_dependency.send(:construct_tables!, join_dependency.send(:join_root))
        end

        join_association = find_join_association(associations)
        join_association.table
      end

      private

      MAJOR = ::ActiveRecord::VERSION::MAJOR
      MINOR = ::ActiveRecord::VERSION::MINOR
      TINY = ::ActiveRecord::VERSION::TINY
      Associations = ::ActiveRecord::Associations

      def find_join_association(associations)
        current = join_dependency.send(:join_root)

        associations.each do |association|
          name = association._reflection.name
          current = current.children.find { |c| c.reflection.name == name }
          break if current.nil?
        end

        current
      end

      def from_relation(relation, &block)
        build(relation, collect_joins(relation, &block))
      end

      def collect_joins(relation, &block)
        joins = []
        joins += relation.joins_values
        joins += relation.left_outer_joins_values if at_least?(5)

        buckets = joins.group_by do |join|
          case join
          when String
            :string_join
          when Hash, Symbol, Array
            :association_join
          when Associations::JoinDependency
            :stashed_join
          when Arel::Nodes::Join
            :join_node
          else
            (block_given? && yield(join)) || raise("unknown class: %s" % join.class.name)
          end
        end
      end

      def build(relation, buckets)
        buckets.default = []
        association_joins         = buckets[:association_join]
        stashed_association_joins = buckets[:stashed_join]
        join_nodes                = buckets[:join_node].uniq
        string_joins              = buckets[:string_join].map(&:strip).uniq

        joins = string_joins.map do |join|
          relation.table.create_string_join(Arel.sql(join)) unless join.blank?
        end.compact

        join_list = join_nodes + joins

        alias_tracker = Associations::AliasTracker.create(relation.klass.connection, relation.table.name, join_list)
        if exactly?(5, 2, 0)
          join_dependency = Associations::JoinDependency.new(relation.klass, relation.table, association_joins, alias_tracker)
        else
          join_dependency = Associations::JoinDependency.new(relation.klass, relation.table, association_joins)
          join_dependency.instance_variable_set(:@alias_tracker, alias_tracker)
        end
        join_nodes.each do |join|
          join_dependency.send(:alias_tracker).aliases[join.left.name.downcase] = 1
        end

        join_dependency
      end

      def exactly?(major, minor = 0, tiny = 0)
        MAJOR == major && MINOR == minor && TINY == tiny
      end

      def at_least?(major, minor = 0, tiny = 0)
        MAJOR > major ||
          (MAJOR == major && MINOR >= minor) ||
          (MAJOR == major && MINOR == minor && TINY == tiny)
      end
    end
  end
end
