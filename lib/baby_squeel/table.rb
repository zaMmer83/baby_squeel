module BabySqueel
  class AssociationNotFoundError < StandardError
    def initialize(scope, name)
      super "Association named '#{name}' was not found on #{scope.model_name}"
    end
  end

  class Table
    attr_accessor :_on, :_join, :_table

    class << self
      def inject_joins(associations = [])
        associations.reverse.inject({}) do |hsh, assoc|
          { assoc._reflection.name => hsh }
        end
      end
    end

    def initialize(scope)
      @scope = scope
      @_table = scope.arel_table
      @_join = Arel::Nodes::InnerJoin
    end

    def [](key)
      Nodes.wrap _table[key]
    end

    def association(name)
      if reflection = @scope.reflect_on_association(name)
        Association.new(self, reflection)
      else
        raise AssociationNotFoundError.new(@scope, name)
      end
    end

    def alias(alias_name)
      clone.alias! alias_name
    end

    def alias!(alias_name)
      self._table = _table.alias(alias_name)
      self
    end

    def outer
      clone.outer!
    end

    def outer!
      self._join = Arel::Nodes::OuterJoin
      self
    end

    def inner
      clone.inner!
    end

    def inner!
      self._join = Arel::Nodes::InnerJoin
      self
    end

    def on(node)
      clone.on! node
    end

    def on!(node)
      self._on = Arel::Nodes::On.new(node)
      self
    end

    def _arel(associations = [])
      if _on
        _join.new(_table, _on)
      else
        completed = 0 # an index of the number of completed joins

        associations.flat_map.with_index do |assoc, i|
          names = self.class.inject_joins associations[0..i]

          result = @scope.joins(names).join_sources.map do |join|
            assoc._join.new(join.left, join.right)
          end

          result[completed..-1].tap { completed = i + 1 }
        end
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
