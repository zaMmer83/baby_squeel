RSpec::Matchers.define :produce_sql do
  match do |actual|
    squish(actual.to_sql) == squish(expected)
  end

  failure_message do |actual|
    "Expected: #{squish(expected)}\nGot:      #{squish(actual.to_sql)}"
  end

  # ActiveSupport String#squish doesn't exist in 4.0
  def squish(str)
    str.gsub(/\A[[:space:]]+/, '')
       .gsub(/[[:space:]]+\z/, '')
       .gsub(/[[:space:]]+/, ' ')
  end
end
