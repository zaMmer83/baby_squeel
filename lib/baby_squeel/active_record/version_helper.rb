require 'baby_squeel/dsl'

module BabySqueel
  module ActiveRecord
    class VersionHelper
      def self.exactly?(version)
        ::ActiveRecord.gem_version == Gem::Version.new(version)
      end

      def self.at_least?(version)
        ::ActiveRecord.gem_version >= Gem::Version.new(version)
      end

      def self.is?(major, minor)
        ::ActiveRecord::VERSION::MAJOR == major && ::ActiveRecord::VERSION::MINOR == minor
      end
    end
  end
end
