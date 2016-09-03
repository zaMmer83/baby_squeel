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
      squish(v) unless v.is_a? Regexp
    }

    "Expected: #{exp}\nGot:      #{act}"
  end

  private

  def squish(value)
    value = value.to_sql if value.respond_to?(:to_sql)
    value.squish.gsub(/\( /, '(').gsub(/ \)/, ')')
  end
end
