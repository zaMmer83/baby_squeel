require 'baby_squeel/nodes'
require 'baby_squeel/table'
require 'baby_squeel/association'

module BabySqueel
  class DSL < Table
    class << self
      # Evaluates a block and unwraps the nodes
      def evaluate(scope, &block)
        Nodes.unwrap evaluate!(scope, &block)
      end

      # Evaluates a block in the context of a DSL instance
      def evaluate!(scope, &block)
        new(scope).evaluate(&block)
      end

      # Evaluates a block specifically for a join. In this
      # case, we'll return an array of Arel join nodes and
      # a list of bind parameters.
      def evaluate_joins(scope, &block)
        dependency = evaluate!(scope, &block)._arel
        join_arel = Nodes.unwrap(dependency._arel)
        [join_arel, dependency.bind_values]
      end

      # Evaluates a block in the context of a new DSL instance
      # and passes all arguments to the block.
      def evaluate_sifter(scope, *args, &block)
        evaluate scope do |root|
          root.instance_exec(*args, &block)
        end
      end
    end

    # Create a SQL function. See Arel::Nodes::NamedFunction.
    #
    # ==== Arguments
    #
    # * +name+ - The name of a SQL function (ex. coalesce).
    # * +args+ - The arguments to be passed to the SQL function.
    #
    # ==== Example
    #     Post.select { func('coalesce', id, 1) }
    #     #=> SELECT COALESCE("posts"."id", 1) FROM "posts"
    #
    def func(name, *args)
      Nodes.wrap Arel::Nodes::NamedFunction.new(name.to_s, args)
    end

    # See Arel::sql
    def sql(value)
      ::Arel.sql value
    end

    # Quotes a string and marks it as SQL
    def quoted(value)
      sql _scope.connection.quote(value)
    end

    # Evaluates a DSL block. If arity is given, this method
    # `yield` itself, rather than `instance_eval`.
    def evaluate(&block)
      if block.arity.zero?
        instance_eval(&block)
      else
        yield(self)
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
