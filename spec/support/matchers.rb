require_relative 'matchers/snapshot'
require_relative 'matchers/sql_formatter'
require_relative 'matchers/match_formatted'
require_relative 'matchers/match_snapshot'

module Matchers
  def snapshot_index(key)
    @snapshot_indexes ||= Hash.new { |h, k| h[k] = 0 }
    @snapshot_indexes[key] += 1
  end

  def match_sql_snapshot
    example = RSpec.current_example
    index = snapshot_index(example.id)
    snapshot = Snapshot.new(example.metadata, index)
    MatchSnapshot.new(snapshot, SQLFormatter)
  end

  def produce_sql(sql)
    MatchFormatted.new(sql, SQLFormatter)
  end
end

RSpec.configure do |config|
  config.include Matchers
end
