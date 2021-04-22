require_relative "queryable"

module BabySqueel
  class Association
    include Queryable

    def initialize(reflection:, foreign_table:, alias_name:) # :nodoc:
      @_reflection = reflection
      @_foreign_table = foreign_table
      @_alias_name = alias_name
    end

    # TODO: Better errors
    def _construct_join(node)
      if _reflection.has_scope?
        raise "Can't join an association with a scope"
      end

      if _reflection.polymorphic?
        raise "Can't join a polymorphic association"
      end

      if _reflection.macro == :composed_of
        raise "Can't join a composed_of association"
      end

      primary_key = _table[_reflection.join_primary_key]
      foreign_key = _foreign_table[_reflection.join_foreign_key]

      node.new(_table, Arel::Nodes::On.new(primary_key.eq(foreign_key)))
    end

    private

    attr_reader :_reflection, :_foreign_table, :_alias_name

    def _model
      _reflection.klass
    end

    def _table
      table = _model.arel_table
      table = table.alias(_alias_name) if _alias_name
      table
    end
  end
end
