require 'baby_squeel/dsl'
require 'baby_squeel/join_dependency/injector'

module BabySqueel
  module ActiveRecord
    module QueryMethods
      # Constructs Arel for ActiveRecord::Base#joins using the DSL.
      def joining(&block)
        joins DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::Base#select using the DSL.
      def selecting(&block)
        select DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::Base#order using the DSL.
      def ordering(&block)
        order DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::Base#group using the DSL.
      def grouping(&block)
        group DSL.evaluate(self, &block)
      end

      # Constructs Arel for ActiveRecord::Base#having using the DSL.
      def when_having(&block)
        having DSL.evaluate(self, &block)
      end

      private

      # This is a monkey patch, and I'm not happy about it.
      # Active Record will call `group_by` on the `joins`. The
      # Injector has a custom `group_by` method that handles
      # BabySqueel::JoinDependency::JoinPath nodes.
      def build_joins(manager, joins)
        super manager, BabySqueel::JoinDependency::Injector.new(joins)
      end
    end
  end
end
