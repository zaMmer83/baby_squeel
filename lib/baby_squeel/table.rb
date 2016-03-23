module BabySqueel
  class AssociationNotFoundError < StandardError
    def initialize(scope, name)
      super "Association named '#{name}' was not found on #{scope.model_name}"
    end
  end

  class Table
    attr_writer :props

    def initialize(scope)
      @scope = scope
    end

    def [](key)
      Nodes.wrap props[:table][key]
    end

    def association(name)
      if reflection = @scope.reflect_on_association(name)
        Association.new(self, reflection)
      else
        raise AssociationNotFoundError.new(@scope, name)
      end
    end

    def alias(alias_name)
      spawn.alias! alias_name
    end

    def alias!(alias_name)
      props.store :table, props[:table].alias(alias_name)
      self
    end

    def outer
      spawn.outer!
    end

    def outer!
      props.store :join, Arel::Nodes::OuterJoin
      self
    end

    def inner
      spawn.inner!
    end

    def inner!
      props.store :join, Arel::Nodes::InnerJoin
      self
    end

    def on(node)
      spawn.on! node
    end

    def on!(node)
      props.store :on, Arel::Nodes::On.new(node)
      self
    end

    def _arel
      props[:join].new(props[:table], props[:on]) if props[:on]
    end

    private

    def props
      @props ||= {
        table: @scope.arel_table,
        join: Arel::Nodes::InnerJoin
      }
    end

    def spawn
      Table.new(@scope).tap do |table|
        table.props = props
      end
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
