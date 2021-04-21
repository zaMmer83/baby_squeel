require_relative "attribute"

module BabySqueel
  class Query
    attr_accessor :_scope

    def initialize(scope)
      @_scope = scope
    end

    def select(*columns)
      self._scope = _scope.select(*columns)
      self
    end

    def where(condition)
      self._scope = _scope.where(condition)
      self
    end

    private

    def respond_to_missing?(name, *)
      _scope.klass.column_names.include?(name.to_s) || super
    end

    def method_missing(name, *)
      if _scope.klass.column_names.include?(name.to_s)
        attribute = _scope.arel_table[name]
        attribute.extend Attribute
        attribute
      else
        super
      end
    end
  end
end
