module BabySqueel
  class JoinDependency
    def initialize(scope, associations = [])
      @scope = scope
      @associations = associations
    end

    # Converts an array of BabySqueel::Associations into an array
    # of Arel join nodes.
    #
    # Each association is built individually so that the correct
    # Arel join node will be used for each individual association.
    def constraints
      @associations.each.with_index.inject([]) do |joins, (assoc, i)|
        inject @associations[0..i], joins, assoc._join
      end
    end

    private

    def inject(associations, theirs, join_node)
      names = join_names associations
      mine = build names, join_node
      theirs + mine[theirs.length..-1]
    end

    def build(names, join_node)
      @scope.joins(names).join_sources.map do |join|
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
