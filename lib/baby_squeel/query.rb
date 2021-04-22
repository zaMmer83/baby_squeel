require_relative "queryable"

module BabySqueel
  class Query
    include Queryable

    attr_reader :_scope

    def initialize(scope)
      self._scope = scope
    end

    def select(*columns)
      self._scope = _scope.select(*columns)
      nil
    end

    def where(clause)
      self._scope = _scope.where(clause)
      nil
    end

    def join(association)
      self._scope = _scope.joins(association._construct_join(Arel::Nodes::InnerJoin))
      nil
    end

    def left_join(association)
      self._scope = _scope.joins(association._construct_join(Arel::Nodes::OuterJoin))
      nil
    end

    def _model
      _scope.klass
    end

    def _alias_name
      nil
    end

    protected

    attr_writer :_scope
  end
end
