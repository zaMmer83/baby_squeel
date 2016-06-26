require 'baby_squeel/join_dependency'

module BabySqueel
  class Table
    attr_accessor :_on, :_join, :_table

    def initialize(arel_table)
      @_table = arel_table
      @_join = Arel::Nodes::InnerJoin
    end

    def _table_name
      arel_table.name
    end

    # See Arel::Table#[]
    def [](key)
      Nodes::Attribute.new(self, key)
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
      return unless _on || associations.any?
      JoinDependency.new(self, associations)
    end

    private

    def resolve(name)
      self[name]
    end

    def respond_to_missing?(name, *)
      resolve(name).present? || super
    end

    def method_missing(name, *args, &block)
      return super if !args.empty? || block_given?

      resolve(name) || begin
        raise NotFoundError.new(_table_name, name)
      end
    end
  end
end
