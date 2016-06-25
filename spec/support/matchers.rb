module SqlMatcher
  # ActiveSupport String#squish doesn't exist in 4.0
  def squish(str)
    str.gsub(/\A[[:space:]]+/, '')
       .gsub(/[[:space:]]+\z/, '')
       .gsub(/[[:space:]]+/, ' ')
       .gsub(/\( /, '(')
       .gsub(/ \)/, ')')
  end
end

RSpec::Matchers.define :produce_sql do
  include SqlMatcher

  match do |actual|
    squish(actual.to_sql) == squish(expected)
  end

  failure_message do |actual|
    "Expected: #{squish(expected)}\nGot:      #{squish(actual.to_sql)}"
  end
end

RSpec::Matchers.define :match_sql do
  include SqlMatcher

  match do |actual|
    squish(actual.to_sql) =~ expected
  end

  failure_message do |actual|
    "Expected #{squish(actual.to_sql)} to match #{expected}"
  end
end
