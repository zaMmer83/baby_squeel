module Matchers
  class MatchFormatted < RSpec::Matchers::BuiltIn::Match
    def initialize(expected, formatter)
      @formatter = formatter
      super(@formatter.normalize(expected))
    end

    def matches?(actual)
      super(@formatter.normalize(actual))
    end

    def expected_formatted
      @formatter.call(@expected)
    end

    def actual_formatted
      @formatter.call(@actual)
    end
  end
end
