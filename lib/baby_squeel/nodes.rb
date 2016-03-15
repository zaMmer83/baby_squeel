require 'baby_squeel/operators'

module BabySqueel
  module Nodes
    class << self
      def wrap(arel)
        if arel.class.parents.include?(Arel)
          Generic.new(arel)
        else
          arel
        end
      end

      def unwrap(node)
        if node.respond_to? :_arel
          node._arel
        elsif node.is_a? Array
          node.map { |n| unwrap(n) }
        else
          node
        end
      end
    end

    # This proxy class allows us to quack like
    # any arel object. When a method missing is
    # hit, we'll instantiate a new proxy object.
    class Proxy < ActiveSupport::ProxyObject
      # Resolve constants the normal way
      def self.const_missing(name)
        ::Object.const_get(name)
      end

      attr_reader :_arel

      def initialize(arel)
        @_arel = Nodes.unwrap(arel)
      end

      def respond_to?(meth, include_private = false)
        meth.to_s == '_arel' || _arel.respond_to?(meth, include_private)
      end

      private

      def method_missing(meth, *args, &block)
        if _arel.respond_to?(meth)
          Nodes.wrap _arel.send(meth, *args, &block)
        else
          super
        end
      end
    end

    # This is a generic proxy class that includes
    # all possible modules. In the future, these
    # proxy classes should be more specific and
    # only include necessary/applicable modules.
    class Generic < Proxy
      include Arel::OrderPredications
      include Operators::Comparison
      include Operators::Equality
      include Operators::Generic
      include Operators::Grouping
      include Operators::Matching
    end

    class Join
      def initialize(left, type = Arel::Nodes::InnerJoin)
        @table = Nodes.unwrap(left) # an Arel::Table
        @type  = type
      end

      def on(node)
        @type.new(@table, Arel::Nodes::On.new(node))
      end

      def as(alias_name)
        Join.new(@table.alias(alias_name), @type)
      end

      def inner
        Join.new(@table, Arel::Nodes::InnerJoin)
      end

      def outer
        Join.new(@table, Arel::Nodes::OuterJoin)
      end
    end
  end
end
