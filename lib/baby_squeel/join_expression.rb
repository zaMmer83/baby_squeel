require 'baby_squeel/join_dependency/builder'
require 'baby_squeel/join_dependency/finder'

module BabySqueel
  class JoinExpression
    JOIN_NODES = {
      Arel::Nodes::InnerJoin => BabySqueel::Nodes::InnerJoin,
      Arel::Nodes::OuterJoin => BabySqueel::Nodes::OuterJoin
    }

    delegate :_scope, :_join, :_on, :_table, to: :@table

    def initialize(table, associations = [])
      @table = table
      @associations = associations
    end

    def find_alias(association)
      builder = JoinDependency::Builder.new(_scope.all)
      builder.add_associations join_names(@associations)

      finder = JoinDependency::Finder.new(builder.to_join_dependency)
      finder.find_alias(association._reflection)
    end

    def bind_values
      return [] unless relation?
      relation = _scope.joins(join_names(@associations))
      relation.arel.bind_values + relation.bind_values
    end

    # Converts an array of BabySqueel::Associations into an array
    # of Arel join nodes.
    #
    # Each association is built individually so that the correct
    # Arel join node will be used for each individual association.
    def _arel
      if _on
        [_join.new(_table, Arel::Nodes::On.new(_on))]
      elsif @associations.all? { |a| inner_join?(a) }
        [join_names(@associations)]
      else
        @associations.each.with_index.inject([]) do |previous, (assoc, i)|
          names = join_names @associations[0..i]
          current = build names, assoc._join
          previous + current[previous.length..-1]
        end
      end
    end

    private

    def inner_join?(association)
      association._join == Arel::Nodes::InnerJoin
    end

    def relation?
      @table.kind_of? BabySqueel::Relation
    end

    def build(names, join_node)
      _scope.joins(names).join_sources.map do |join|
        JOIN_NODES[join_node].new(join.left, join.right, names)
      end
    end

    def join_names(associations = [])
      associations.reverse.inject({}) do |names, assoc|
        { assoc._reflection.name => names }
      end
    end
  end
end
