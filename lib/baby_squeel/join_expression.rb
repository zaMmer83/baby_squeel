require 'baby_squeel/join_dependency/builder'
require 'baby_squeel/join_dependency/finder'
require 'baby_squeel/join_dependency/join_path'

module BabySqueel
  class JoinExpression
    attr_reader :associations
    delegate :_scope, :_join, :_on, :_table, to: :@table

    def initialize(table, associations = [])
      @table = table
      @associations = associations
    end

    def find_alias(association)
      builder = JoinDependency::Builder.new(_scope.all)
      builder.ensure_associated(all_join_names)

      finder = JoinDependency::Finder.new(builder.to_join_dependency)
      finder.find_alias(association._reflection)
    end

    # Converts an array of BabySqueel::Associations into an array
    # of Arel join nodes.
    #
    # Each association is built individually so that the correct
    # Arel join node will be used for each individual association.
    def _arel
      if _on
        [_join.new(_table, Arel::Nodes::On.new(_on))]
      elsif all_inner_joins?
        [all_join_names]
      else
        [JoinDependency::JoinPath.new(associations)]
      end
    end

    private

    def all_inner_joins?
      associations.all? do |assoc|
        assoc._join == Arel::Nodes::InnerJoin
      end
    end

    def all_join_names
      associations.reverse.inject({}) do |names, assoc|
        { assoc._reflection.name => names }
      end
    end
  end
end
