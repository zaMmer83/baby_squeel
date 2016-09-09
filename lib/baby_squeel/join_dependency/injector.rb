module BabySqueel
  module JoinDependency
    # This class allows BabySqueel to slip custom
    # joins_values into Active Record's JoinDependency
    class Injector < Array # :nodoc:
      def initialize(joins)
        @joins = joins
      end

      # Active Record will call group_by on this object
      # in ActiveRecord::QueryMethods#build_joins. This
      # allows BabySqueel::JoinExpressions to be treated
      # like typical join hashes until Polyamorous can
      # deal with them.
      def group_by(&block)
        @joins.group_by do |join|
          case join
          when BabySqueel::JoinExpression
            :association_join
          else
            yield join
          end
        end
      end
    end
  end
end
