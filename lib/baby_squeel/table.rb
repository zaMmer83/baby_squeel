module BabySqueel
  class AssociationNotFoundError < StandardError
    def initialize(scope, name)
      super "Association named '#{name}' was not found on #{scope.model_name}"
    end
  end

  class Table
    def initialize(scope)
      @scope = scope
    end

    def [](key)
      Nodes.wrap @scope.arel_table[key]
    end

    def association(name)
      if reflection = @scope.reflect_on_association(name)
        Table.new(reflection.klass)
      else
        raise AssociationNotFoundError.new(@scope, name)
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

    # Unfortunately, there's no way to respond_to? a SQL function
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
