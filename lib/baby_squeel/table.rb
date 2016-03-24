require 'baby_squeel/join_dependency'

module BabySqueel
  class AssociationNotFoundError < StandardError
    def initialize(scope, name)
      super "Association named '#{name}' was not found on #{scope.model_name}"
    end
  end

  class Table
    attr_accessor :_on, :_join, :_table

    def initialize(scope)
      @scope = scope
      @_table = scope.arel_table
      @_join = Arel::Nodes::InnerJoin
    end

    # See Arel::Table#[]
    def [](key)
      Nodes.wrap _table[key]
    end

    # Constructs a new BabySqueel::Association. Raises
    # an exception if the association is not found.
    def association(name)
      if reflection = @scope.reflect_on_association(name)
        Association.new(self, reflection)
      else
        raise AssociationNotFoundError.new(@scope, name)
      end
    end

    # Alias a table. This is only possible when joining
    # an association explicitly.
    def alias(alias_name)
      clone.alias! alias_name
    end

    def alias!(alias_name)
      self._table = _table.alias(alias_name)
      self
    end

    # Instruct the table to be joined with an INNER JOIN.
    def outer
      clone.outer!
    end

    def outer!
      self._join = Arel::Nodes::OuterJoin
      self
    end

    # Instruct the table to be joined with an INNER JOIN.
    def inner
      clone.inner!
    end

    def inner!
      self._join = Arel::Nodes::InnerJoin
      self
    end

    # Specify an explicit join.
    def on(node)
      clone.on! node
    end

    def on!(node)
      self._on = Arel::Nodes::On.new(node)
      self
    end

    # This method will be invoked by BabySqueel::Nodes::unwrap. When called,
    # there are two possible outcomes:
    #
    # 1. Join explicitly using an on clause.
    # 2. Resolve the assocition's join clauses using ActiveRecord.
    #
    def _arel(associations = [])
      if _on
        _join.new(_table, _on)
      else
        JoinDependency.new(@scope, associations).constraints
      end
    end

    private

    def resolve(name)
      if @scope.column_names.include?(name.to_s)
        self[name]
      elsif @scope.reflect_on_association(name)
        association(name)
      end
    end

    def respond_to_missing?(name, *)
      resolve(name).present? || super
    end

    def method_missing(name, *args, &block)
      if !args.empty? || block_given?
        super
      else
        resolve(name) || super
      end
    end
  end
end
