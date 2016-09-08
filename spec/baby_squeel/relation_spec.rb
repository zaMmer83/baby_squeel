require 'spec_helper'
require 'baby_squeel/relation'
require 'shared_examples/table'
require 'shared_examples/relation'

describe BabySqueel::Relation do
  subject(:table) { create_relation Post }

  include_examples 'a table'
  include_examples 'a relation'
end
