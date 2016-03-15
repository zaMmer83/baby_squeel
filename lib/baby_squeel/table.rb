module BabySqueel
  class AssociationNotFoundError < StandardError
    def initialize(scope, name)
      super "Association named '#{name}' was not found on #{scope.model_name}"
    end
  end

  class Table
    def initialize(scope)
      @scope = scope
      @arel = scope.arel_table
      @join_type = Arel::Nodes::InnerJoin
    end

    def [](key)
      Nodes.wrap @arel[key]
    end

    def association(name)
      if reflection = @scope.reflect_on_association(name)
        Table.new(reflection.klass)
      else
        raise AssociationNotFoundError.new(@scope, name)
      end
    end

    def alias(alias_name)
      spawn.alias! alias_name
    end

    def alias!(alias_name)
      @arel = @arel.alias(alias_name)
      self
    end

    def outer
      spawn.outer!
    end

    def outer!
      @join_type = Arel::Nodes::OuterJoin
      self
    end

    def inner
      spawn.inner!
    end

    def inner!
      @join_type = Arel::Nodes::InnerJoin
      self
    end

    def on(node)
      @join_type.new(@arel, Arel::Nodes::On.new(node))
    end

    private

    def spawn
      Table.new(@scope)
    end

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
