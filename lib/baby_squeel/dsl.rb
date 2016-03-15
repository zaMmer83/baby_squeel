require 'baby_squeel/nodes'

module BabySqueel
  class DSL
    class AssociationNotFoundError < StandardError
      def initialize(scope, name)
        super "Association named '#{name}' was not found on #{scope.model_name}"
      end
    end

    def self.evaluate(scope, &block)
      new(scope).evaluate(&block)
    end

    def initialize(scope)
      @scope = scope
    end

    def [](key)
      Nodes.wrap @scope.arel_table[key]
    end

    def func(name, *args)
      Nodes.wrap Arel::Nodes::NamedFunction.new(name.to_s, args)
    end

    def association(name)
      if reflection = @scope.reflect_on_association(name)
        DSL.new(reflection.klass)
      else
        raise AssociationNotFoundError.new(@scope, name)
      end
    end

    def evaluate(&block)
      if block.arity.zero?
        Nodes.unwrap instance_eval(&block)
      else
        Nodes.unwrap yield(self)
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
      if block_given?
        super
      elsif args.empty?
        resolve(name) || super
      else
        func(name, *args)
      end
    end
  end
end
