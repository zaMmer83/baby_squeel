require 'spec_helper'
require 'baby_squeel/table'
require 'shared_examples/table'

describe BabySqueel::Table do
  subject(:table) {
    BabySqueel::Relation.new(Post)
  }

  include_examples 'a table'
end
