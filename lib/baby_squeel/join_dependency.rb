module BabySqueel
  class JoinDependency
    attr_reader :bind_values

    def initialize(table, associations = [])
      @table = table
      @bind_values = []
      @associations = associations
    end

    # Converts an array of BabySqueel::Associations into an array
    # of Arel join nodes.
    #
    # Each association is built individually so that the correct
    # Arel join node will be used for each individual association.
    def _arel
      if @table._on
        [@table._join.new(@table._table, @table._on)]
      else
        @associations.each.with_index.inject([]) do |joins, (assoc, i)|
          inject @associations[0..i], joins, assoc._join
        end
      end
    end

    private

    def inject(associations, theirs, join_node)
      names = join_names associations
      mine = build names, join_node
      theirs + mine[theirs.length..-1]
    end

    def build(names, join_node)
      relation = @table._scope.joins(names)

      @bind_values = relation.arel.bind_values
      @bind_values += relation.bind_values

      relation.join_sources.map do |join|
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
