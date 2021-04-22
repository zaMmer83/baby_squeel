require_relative "sql"
require_relative "table"
require_relative "queryable"

module BabySqueel
  class Query
    include Queryable

    def initialize(scope) # :nodoc:
      self._scope = scope
    end

    def _evaluate(&block) # :nodoc:
      if block.arity.zero?
        instance_eval(&block)
      else
        instance_exec(self, &block)
      end

      _scope
    end

    def table(name, alias_name = nil)
      Table.new(name, alias_name: alias_name)
    end

    def select(*columns)
      self._scope = _scope.select(columns)
      nil
    end

    def order_by(*columns)
      self._scope = _scope.order(columns)
      nil
    end

    def where(clause)
      self._scope = _scope.where(clause)
      nil
    end

    def where_not(clause)
      self._scope = _scope.where.not(clause)
      nil
    end

    def group_by(*clauses)
      self._scope = _scope.group(clauses)
      nil
    end

    def having(clause)
      self._scope = _scope.having(clause)
      nil
    end

    def join(other, on: nil)
      self._scope = _scope.joins(_join(other, on, Arel::Nodes::InnerJoin))
      nil
    end

    def left_join(other, on: nil)
      self._scope = _scope.joins(_join(other, on, Arel::Nodes::OuterJoin))
      nil
    end

    def sql
      SQL.new(_scope.connection)
    end

    def _model # :nodoc:
      _scope.klass
    end

    protected

    attr_accessor :_scope

    private

    def _join(other, on, node)
      case other
      when Table
        if on
          node.new(other._table, Arel::Nodes::On.new(on))
        else
          raise "An `:on` clause is required"
        end
      when Association
        if on
          node.new(other._table, Arel::Nodes::On.new(on))
        else
          other._construct_join(node)
        end
      else
        raise "Unsupported join: #{other.inspect}"
      end
    end
  end
end
