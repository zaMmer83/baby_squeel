module SqlFormatter
  KEYWORDS = %w(
    WHERE
    ORDER\ BY
    GROUP\ BY
    HAVING
    INNER\ JOIN
    LEFT\ OUTER\ JOIN
    LIMIT
  )

  def self.call(value, &block)
    value.gsub(/#{KEYWORDS.join('|')}/, &block)
  end
end

RSpec::Matchers.define :produce_sql do
  match do |actual|
    if expected.is_a? Regexp
      squish(actual) =~ expected
    else
      squish(actual) == squish(expected)
    end
  end

  failure_message do |actual|
    act, exp = [actual, expected].map { |v|
      v.is_a?(Regexp) ? v : sql_format(v)
    }

    "Expected:\n  #{exp}\nGot:\n  #{act}"
  end

  private

  def sql_format(value)
    SqlFormatter.call squish(value) do |match|
      "\n  #{match}"
    end
  end

  def squish(value)
    value = value.to_sql if value.respond_to?(:to_sql)
    value.squish.gsub(/\( /, '(').gsub(/ \)/, ')')
  end
end
