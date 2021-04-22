require_relative "queryable"

module BabySqueel
  class Association
    include Queryable

    def initialize(parent, reflection, alias_name:)
      @_parent = parent
      @_reflection = reflection
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

      table = _reflection.klass.arel_table
      table = table.alias(_alias_name) if _alias_name

      foreign_table = _parent._model.arel_table
      foreign_table = foreign_table.alias(_parent._alias_name) if _parent._alias_name

      pk = _reflection.join_primary_key
      fk = _reflection.join_foreign_key

      join = foreign_table.join(table, node)
      join = join.on(table[pk].eq(foreign_table[fk]))
      join.join_sources
    end

    def _model
      _reflection.klass
    end

    def _alias_name
      @_alias_name
    end

    private

    attr_reader :_parent, :_reflection
  end
end
