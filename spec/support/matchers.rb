require 'yaml'

module SQLFormatter
  KEYWORDS = %w(
    WHERE
    ORDER\ BY
    GROUP\ BY
    HAVING
    INNER\ JOIN
    LEFT\ OUTER\ JOIN
    LIMIT
  )

  INDENT = "\n        "

  def self.call(value)
    value = value.squish.gsub(/\( /, '(').gsub(/ \)/, ')')
    value.gsub(/#{KEYWORDS.join('|')}/) { |m| "#{INDENT}#{m.strip}" }.prepend(INDENT)
  end

  def self.legacy_format(value)
    value.squish.gsub(/#{KEYWORDS.join('|')}/) { |m| "\n  #{m.strip}" }
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
    SQLFormatter.legacy_format(squish(value))
  end

  def squish(value)
    value = value.to_sql if value.respond_to?(:to_sql)
    value.squish.gsub(/\( /, '(').gsub(/ \)/, ')')
  end
end

class Snapshot
  attr_reader :meta, :index

  def initialize(meta, index)
    @meta = meta
    @index = index
  end

  def name
    "#{meta[:full_description]} #{index}"
  end

  def path
    spec = meta[:absolute_file_path]
    file = "#{File.basename(spec, '.*')}.yaml"
    relative = File.join('..', '__snapshots__', file)
    File.expand_path(relative, spec)
  end

  def read
    data[name]
  end

  def write(value)
    puts "Writing #{name}"

    data[name] = value

    File.open path, 'w' do |f|
      f.write data.to_yaml
    end

    value
  end

  private

  def data
    @data ||=
      begin
        YAML.load_file(path) || {}
      rescue Errno::ENOENT
        {}
      end
  end
end

class SnapshotMatcher < RSpec::Matchers::BuiltIn::Eq
  def initialize(snapshot, formatter: :itself.to_proc)
    @snapshot = snapshot
    @formatter = formatter
    super(@snapshot.read)
  end

  def matches?(actual)
    actual = actual.to_sql if actual.respond_to?(:to_sql)

    if @snapshot.read && !ENV['UPDATE_SNAPSHOTS']
      super(actual)
    else
      @snapshot.write(actual)
      true
    end
  end

  def expected_formatted
    @formatter.call(@expected)
  end

  def actual_formatted
    @formatter.call(@actual)
  end
end

module Matchers
  def snapshot_index(key)
    @snapshot_indexes ||= Hash.new { |h, k| h[k] = 0 }
    @snapshot_indexes[key] += 1
  end

  def match_snapshot(**opts)
    example = RSpec.current_example
    index = snapshot_index(example.id)
    snapshot = Snapshot.new(example.metadata, index)
    SnapshotMatcher.new(snapshot, **opts)
  end

  def match_sql_snapshot
    match_snapshot(formatter: SQLFormatter)
  end
end

RSpec.configure do |config|
  config.include Matchers
end
