module SqlMatcher
  private

  def squish(str)
    str = str.to_sql if str.respond_to?(:to_sql)
    str.squish.gsub(/\( /, '(').gsub(/ \)/, ')')
  end
end

RSpec::Matchers.define :produce_sql do
  include SqlMatcher

  match do |actual|
    squish(actual) == squish(expected)
  end

  failure_message do |actual|
    "Expected: #{squish(expected)}\nGot:      #{squish(actual.to_sql)}"
  end
end

RSpec::Matchers.define :match_sql do
  include SqlMatcher

  match do |actual|
    squish(actual) =~ expected
  end

  failure_message do |actual|
    "Expected #{squish(actual.to_sql)} to match #{expected}"
  end
end
