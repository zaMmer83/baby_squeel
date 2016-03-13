module BabySqueel
  class DSL
    def self.evaluate(scope, &block)
      new(scope).evaluate(&block)
    end

    def initialize(scope)
      @scope = scope
    end

    def [](key)
      @scope.arel_table[key]
    end

    def func(name, *args)
      Arel::Nodes::NamedFunction.new(name.to_s, args)
    end

    def evaluate(&block)
      if block.arity.zero?
        [instance_eval(&block)]
      else
        [block.call(self)]
      end
    end

    private

    def respond_to_missing?(name, *)
      @scope.column_names.include?(name.to_s) ||
        !@scope.reflect_on_association(name).nil?
    end

    def method_missing(name, *args, &block)
      if args.empty? && !block_given?
        if @scope.column_names.include?(name.to_s)
          @scope.arel_table[name]
        elsif assoc = @scope.reflect_on_association(name)
          assoc.klass.arel_table
        else
          super
        end
      else
        super
      end
    end
  end
end
