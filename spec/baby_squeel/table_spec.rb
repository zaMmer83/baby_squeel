require 'spec_helper'
require 'baby_squeel/table'
require 'shared_examples/table'

describe BabySqueel::Table do
  subject(:table) {
    BabySqueel::Table.new(Post)
  }

  let(:association) {
    BabySqueel::Association.new(
      BabySqueel::Table.new(Author),
      Author.reflect_on_association(:posts)
    )
  }

  include_examples 'a table'
end
