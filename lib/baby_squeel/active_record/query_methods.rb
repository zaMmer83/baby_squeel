require 'baby_squeel/dsl'
require 'baby_squeel/join_dependency'
require 'baby_squeel/active_record/version_helper'

module BabySqueel
  module ActiveRecord
    module QueryMethods
      # This class allows BabySqueel to slip custom
      # joins_values into Active Record's JoinDependency
      module Injector6_1
        def each(&block)
          super do |join|
            if join.is_a?(BabySqueel::Join)
              result = block.binding.local_variables.include?(:result) && block.binding.local_variable_get(:result)
              result << join if result
              join
            else
              block.call(join)
            end
          end
        end
      end

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

      if BabySqueel::ActiveRecord::VersionHelper.at_least_6_1?
        # https://github.com/rails/rails/commit/c0c53ee9d28134757cf1418521cb97c4a135f140
        def select_association_list(*args)
          args[0].extend(BabySqueel::ActiveRecord::QueryMethods::Injector6_1)
          super *args
        end

        def construct_join_dependency(associations, join_type)
          super(associations, join_type).extend(BabySqueel::JoinDependency::Injector6_1)
        end
      end

      # This is a monkey patch, and I'm not happy about it.
      def build_joins(*args)
        if BabySqueel::ActiveRecord::VersionHelper.at_least_6_1?
          # This 'fix' is moved to:
          # BabySqueel::ActiveRecord::QueryMethods#select_association_list
        elsif BabySqueel::ActiveRecord::VersionHelper.at_least_6_0?
          # Active Record will call `each` on the `joins`. The
          # Injector has a custom `each` method that handles
          # BabySqueel::Join nodes.
          args[1] = BabySqueel::JoinDependency::Injector6_0.new(args.second)
        else
          # Rails 5.2

          # Active Record will call `group_by` on the `joins`. The
          # Injector has a custom `group_by` method that handles
          # BabySqueel::Join nodes.
          args[1] = BabySqueel::JoinDependency::Injector5_2.new(args.second)
        end

        super *args
      end
    end
  end
end
