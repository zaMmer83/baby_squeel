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

      if ::ActiveRecord::VERSION::MAJOR >= 5
        def plucking(&block)
          pluck DSL.evaluate(self, &block)
        end
      elsif ::ActiveRecord::VERSION::STRING >= '4.2.0'
        def plucking(&block)
          relation = selecting(&block)
          binds = relation.arel.bind_values + bind_values
          result = klass.connection.select_all(relation.arel, nil, binds)
          result.cast_values(klass.column_types)
        end
      else
        def plucking(&block)
          relation = selecting(&block)
          binds = relation.arel.bind_values + bind_values
          result = klass.connection.select_all(relation.arel, nil, binds)
          columns = result.columns.map do |key|
            klass.column_types.fetch(key) {
              result.column_types.fetch(key) { result.identity_type }
            }
          end

          result = result.rows.map do |values|
            values = result.columns.zip(values).map do |column_name, value|
              single_attr_hash = { column_name => value }
              klass.initialize_attributes(single_attr_hash).values.first
            end

            columns.zip(values).map { |column, value| column.type_cast value }
          end
          columns.one? ? result.map!(&:first) : result
        end
      end

      private

      # This is a monkey patch, and I'm not happy about it.
      # Active Record will call `group_by` on the `joins`. The
      # Injector has a custom `group_by` method that handles
      # BabySqueel::JoinExpression nodes.
      def build_joins(manager, joins)
        super manager, BabySqueel::JoinDependency::Injector.new(joins)
      end
    end
  end
end
