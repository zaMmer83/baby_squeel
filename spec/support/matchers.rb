require 'anbt-sql-formatter/formatter'

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
    rule = AnbtSql::Rule.new
    rule.keyword = AnbtSql::Rule::KEYWORD_UPPER_CASE
    rule.indent_string = '  '
    rule.kw_minus1_indent_nl_x_plus1_indent += ['INNER JOIN', 'LEFT OUTER JOIN']
    rule.kw_multi_words += ['INNER JOIN', 'LEFT OUTER JOIN']
    formatter = AnbtSql::Formatter.new(rule)
    formatter.format squish(value)
  end

  def squish(value)
    value = value.to_sql if value.respond_to?(:to_sql)
    value.squish.gsub(/\( /, '(').gsub(/ \)/, ')')
  end
end
