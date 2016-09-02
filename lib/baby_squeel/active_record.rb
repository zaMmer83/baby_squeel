require 'baby_squeel/dsl'

module BabySqueel
  module ActiveRecord
    module Base
      delegate :joining, :joining!, :selecting, :ordering,
               :grouping, :when_having, to: :all

      def sifter(name, &block)
        define_singleton_method "sift_#{name}" do |*args|
          DSL.evaluate_sifter(self, *args, &block)
        end
      end
    end

    # This allow us to prevent duplicate nodes from being joined
    # Normal association names like :author can be compared to
    # BabySqueel::Nodes::InnerJoin and deduped.
    class JoinsValues < Array
      def +(additions)
        values = JoinsValues.new(to_a)
        values.add!(additions)
        values
      end

      def add!(additions, &block)
        additions.each do |addition|
          if index = find_same_index(addition)
            # This addition is a duplicate, replace the existing
            # item if it isn't a BabySqueel join node
            self[index] = addition unless node?(self[index])
          else
            self << addition
          end
        end
        self
      end

      private

      def find_same_index(a)
        find_index do |b|
          node?(a) && a.eql?(b) || node?(b) && b.eql?(a)
        end
      end

      def node?(item)
        item.respond_to? :same_association?
      end
    end

    module QueryMethods
      # Constructs Arel for ActiveRecord::Base#joins using the DSL.
      def joining(&block)
        exprs, binds = DSL.evaluate_joins(self, &block)
        spawn.joining! exprs, binds
      end

      def joining!(exprs, binds = [])
        unless joins_values.kind_of? JoinsValues
          self.joins_values = JoinsValues.new(joins_values)
        end

        joins! exprs
        self.bind_values += binds
        self
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
    end

    module WhereChain
      # Constructs Arel for ActiveRecord::Base#where using the DSL.
      def has(&block)
        @scope.where! DSL.evaluate(@scope, &block)
        @scope
      end
    end
  end
end
