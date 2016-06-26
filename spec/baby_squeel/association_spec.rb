require 'spec_helper'
require 'baby_squeel/association'
require 'shared_examples/table'

describe BabySqueel::Association do
  subject(:table) {
    BabySqueel::Association.new(
      BabySqueel::Relation.new(Author),
      Author.reflect_on_association(:posts)
    )
  }

  it_behaves_like 'a table'
end
