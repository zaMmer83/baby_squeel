module BabySqueel
  module JoinDependency
    class Injector < Array
      def initialize(joins)
        @joins = joins
      end

      def group_by(&block)
        @joins.group_by do |join|
          case join
          when BabySqueel::JoinDependency::JoinPath
            :association_join
          else
            yield join
          end
        end
      end
    end
  end
end
