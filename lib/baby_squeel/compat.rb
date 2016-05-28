module BabySqueel
  module Compat
    def self.enable!
      ::ActiveRecord::Base.singleton_class.prepend QueryMethods
      ::ActiveRecord::Relation.prepend QueryMethods
    end

    module QueryMethods
      def joins(*args, &block)
        if block_given? && args.empty?
          joining(&block)
        else
          super
        end
      end

      def select(*args, &block)
        if block_given? && args.empty? && block.arity.zero?
          selecting(&block)
        else
          super
        end
      end

      def order(*args, &block)
        if block_given? && args.empty?
          ordering(&block)
        else
          super
        end
      end

      def group(*args, &block)
        if block_given? && args.empty?
          grouping(&block)
        else
          super
        end
      end

      def having(*args, &block)
        if block_given? && args.empty?
          when_having(&block)
        else
          super
        end
      end

      def where(*args, &block)
        if block_given? && args.empty?
          super DSL.evaluate(self, &block)
        else
          super
        end
      end
    end
  end
end
