RSpec::Matchers.define :produce_sql do
  match do |actual|
    actual.to_sql.squish.include? expected.squish
  end

  failure_message do |actual|
    "Expected: #{expected.squish}\nGot:      #{actual.to_sql.squish}"
  end
end
