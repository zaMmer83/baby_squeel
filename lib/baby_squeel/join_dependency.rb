module BabySqueel
  class JoinDependency
    delegate :_scope, :_join, :_on, :_table, to: :@table

    def initialize(table, associations = [])
      @table = table
      @associations = associations
    end

    if ActiveRecord::VERSION::STRING < '4.1.0'
      def bind_values
        return [] unless relation?
        _scope.joins(join_names(@associations)).bind_values
      end
    else
      def bind_values
        return [] unless relation?
        relation = _scope.joins(join_names(@associations))
        relation.arel.bind_values + relation.bind_values
      end
    end

    # Converts an array of BabySqueel::Associations into an array
    # of Arel join nodes.
    #
    # Each association is built individually so that the correct
    # Arel join node will be used for each individual association.
    def _arel
      if _on
        [_join.new(_table, _on)]
      else
        @associations.each.with_index.inject([]) do |previous, (assoc, i)|
          names = join_names @associations[0..i]
          current = build names, assoc._join
          previous + current[previous.length..-1]
        end
      end
    end

    private

    def relation?
      @table.kind_of? BabySqueel::Relation
    end

    def build(names, join_node)
      _scope.unscoped.joins(names).join_sources.map do |join|
        join_node.new(join.left, join.right)
      end
    end

    def join_names(associations = [])
      associations.reverse.inject({}) do |names, assoc|
        { assoc._reflection.name => names }
      end
    end
  end
end
