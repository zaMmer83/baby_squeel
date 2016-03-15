require 'baby_squeel/nodes'
require 'baby_squeel/table'

module BabySqueel
  class DSL
    def self.evaluate(scope, &block)
      new(scope).evaluate(&block)
    end

    def initialize(scope)
      @table = Table.new(scope)
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

    def respond_to_missing?(meth, include_all = false)
      @table.respond_to?(meth, include_all)
    end

    def method_missing(meth, *args, &block)
      if @table.respond_to?(meth)
        @table.send(meth, *args, &block)
      elsif !args.empty? && !block_given?
        func(meth, args)
      else
        super
      end
    end
  end
end
