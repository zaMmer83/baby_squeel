require 'baby_squeel/dsl'
require 'baby_squeel/join_dependency'

module BabySqueel
  module ActiveRecord
    module QueryMethods
      # Constructs Arel for ActiveRecord::QueryMethods#joins using the DSL.
      def joining(&block)
        joins DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::QueryMethods#select using the DSL.
      def selecting(&block)
        select DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::QueryMethods#order using the DSL.
      def ordering(&block)
        order DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::QueryMethods#reorder using the DSL.
      def reordering(&block)
        reorder DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::QueryMethods#group using the DSL.
      def grouping(&block)
        group DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::QueryMethods#having using the DSL.
      def when_having(&block)
        having DSL.evaluate(self, &block)
      end

      private

      # This is a monkey patch, and I'm not happy about it.
      def build_joins(*args)
        if ::ActiveRecord::VERSION::MAJOR == 5 && ::ActiveRecord::VERSION::MINOR == 2
          # Active Record will call `group_by` on the `joins`. The
          # Injector has a custom `group_by` method that handles
          # BabySqueel::Join nodes.
          args[1] = BabySqueel::JoinDependency::Injector5_2.new(args.second)
        elsif ::ActiveRecord::VERSION::MAJOR == 6 && ::ActiveRecord::VERSION::MINOR == 0
          # Active Record will call `each` on the `joins`. The
          # Injector has a custom `each` method that handles
          # BabySqueel::Join nodes.
          args[1] = BabySqueel::JoinDependency::Injector6_0.new(args.second)
        else
          # Please help baby_squeel to get ready for Rails 6.1.
          # I think you can start at this commits:
          # https://github.com/rails/rails/commit/c0c53ee9d28134757cf1418521cb97c4a135f140
          # https://github.com/rails/rails/commit/f799f019641f432e9d1260e38846129b40f81d28
          # We might monkey patch select_association_list instead of build_joins.
          raise('This method or the Injector probably need to change')
        end

        super *args
      end
    end
  end
end
