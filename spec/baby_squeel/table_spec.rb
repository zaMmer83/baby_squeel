require 'spec_helper'
require 'baby_squeel/table'
require 'shared_examples/table'

describe BabySqueel::Table do
  subject(:table) {
    BabySqueel::Table.new(
      Arel::Table.new(:posts)
    )
  }

  include_examples 'a table'
end
