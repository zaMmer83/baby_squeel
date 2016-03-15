require 'spec_helper'
require 'baby_squeel/table'

describe BabySqueel::Table do
  subject(:table) {
    BabySqueel::Table.new(Post)
  }

  include_examples 'a table'
end
