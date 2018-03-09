require_relative 'matchers/snapshot'
require_relative 'matchers/sql_formatter'
require_relative 'matchers/match_formatted'
require_relative 'matchers/match_snapshot'

module Matchers
  def self.suffix
    version = ActiveRecord::VERSION::STRING
    version = version.split('.').first(2).join('.')
    "(Active Record: v#{version})"
  end

  def snapshot_index(key)
    @snapshot_indexes ||= Hash.new { |h, k| h[k] = 0 }
    @snapshot_indexes[key] += 1
  end

  def match_sql_snapshot(version: false)
    example = RSpec.current_example
    index = snapshot_index(example.id)
    suffix = Matchers.suffix if version
    snapshot = Snapshot.new(example.metadata, index, suffix: suffix)
    MatchSnapshot.new(snapshot, SQLFormatter)
  end

  def produce_sql(sql)
    MatchFormatted.new(sql, SQLFormatter)
  end
end

RSpec.configure do |config|
  config.include Matchers
end
