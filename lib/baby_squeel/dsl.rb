require 'baby_squeel/nodes'
require 'baby_squeel/table'
require 'baby_squeel/association'

module BabySqueel
  class DSL < Table
    def self.evaluate(scope, &block)
      new(scope).evaluate(&block)
    end

    def func(name, *args)
      Nodes.wrap Arel::Nodes::NamedFunction.new(name.to_s, args)
    end

    def evaluate(&block)
      if block.arity.zero?
        Nodes.unwrap instance_eval(&block)
      else
        Nodes.unwrap yield(self)
      end
    end

    private

    def method_missing(meth, *args, &block)
      if !args.empty? && !block_given?
        func(meth, args)
      else
        super
      end
    end
  end
end
