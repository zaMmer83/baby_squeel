module BabySqueel
  module Compat
    # Monkey-patches BabySqueel and ActiveRecord
    # in order to behave more like Squeel
    def self.enable!
      BabySqueel::DSL.prepend BabySqueel::Compat::DSL
      ::ActiveRecord::Base.singleton_class.prepend QueryMethods
      ::ActiveRecord::Relation.prepend QueryMethods
    end

    module DSL
      # An alias for BabySqueel::DSL#sql
      def `(str)
        sql(str)
      end

      # Allows you to call out of an instance_eval'd block.
      def my(&block)
        @caller.instance_eval(&block)
      end

      # Remember the original binding of the block
      def evaluate(&block)
        @caller = block.binding.eval('self')
        super
      end
    end

    module QueryMethods
      # Overrides ActiveRecord::QueryMethods#joins
      def joins(*args, &block)
        if block_given? && args.empty?
          joining(&block)
        else
          super
        end
      end

      # Heads up, Array#select conflicts with
      # ActiveRecord::QueryMethods#select. So, if arity
      # is given to the block, we'll use Array#select.
      # Otherwise, you'll be in a DSL block.
      #
      #    Model.select { This is DSL }
      #    Model.select { |m| This is not DSL }
      #
      def select(*args, &block)
        if block_given? && args.empty? && block.arity.zero?
          selecting(&block)
        else
          super
        end
      end

      # Overrides ActiveRecord::QueryMethods#order
      def order(*args, &block)
        if block_given? && args.empty?
          ordering(&block)
        else
          super
        end
      end

      # Overrides ActiveRecord::QueryMethods#group
      def group(*args, &block)
        if block_given? && args.empty?
          grouping(&block)
        else
          super
        end
      end

      # Overrides ActiveRecord::QueryMethods#having
      def having(*args, &block)
        if block_given? && args.empty?
          when_having(&block)
        else
          super
        end
      end

      # Overrides ActiveRecord::QueryMethods#where
      def where(*args, &block)
        if block_given? && args.empty?
          where.has(&block)
        else
          super
        end
      end
    end
  end
end
