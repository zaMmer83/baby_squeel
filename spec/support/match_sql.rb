module MatchSQL
  class Matcher < RSpec::Matchers::BuiltIn::Match
    KEYWORDS = [
      "FROM",
      "WHERE",
      "AND",
      "ORDER BY",
      "GROUP BY",
      "HAVING",
      "INNER JOIN",
      "LEFT OUTER JOIN"
    ]

    def initialize(expected)
      super format_sql(expected.squish)
    end

    def matches?(actual)
      super format_sql(actual)
    end

    def expected_formatted
      format_sql @expected
    end

    def actual_formatted
      format_sql @actual
    end

    private

    def format_sql(value)
      value.gsub(/\s(#{KEYWORDS.join("|")})/) { "\n#{_1.lstrip}" }
    end
  end

  def match_sql(expected)
    Matcher.new(expected)
  end
end
