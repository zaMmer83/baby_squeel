require 'baby_squeel/dsl'

module BabySqueel
  module ActiveRecord
    class VersionHelper
      def self.at_least_6_1?
        ::ActiveRecord::VERSION::MAJOR > 6 ||
          ::ActiveRecord::VERSION::MAJOR == 6 && ::ActiveRecord::VERSION::MINOR >= 1
      end

      def self.at_least_6_0?
        ::ActiveRecord::VERSION::MAJOR >= 6
      end

      def self.at_least_5_2_3?
        at_least_6_0? ||
          ::ActiveRecord::VERSION::MAJOR >= 5 && ::ActiveRecord::VERSION::MINOR >= 2 && ::ActiveRecord::VERSION::TINY >= 3
      end
    end
  end
end
