require 'spec_helper'

describe BabySqueel::JoinDependency::JoinPath do
  let(:relation)     { BabySqueel::Relation.new(Author) }

  let(:reflection1)  { Author.reflect_on_association(:posts) }
  let(:association1) { BabySqueel::Association.new(relation, reflection1) }

  let(:reflection2)  { Post.reflect_on_association(:comments) }
  let(:association2) { BabySqueel::Association.new(association1, reflection2) }

  subject(:join_path) { described_class.new([association1, association2]) }

  describe '#add_to_tree' do
    let(:tree) do
      {}.tap { |hsh| join_path.add_to_tree(hsh) }
    end

    it 'propogates down to the associations' do
      expect(association1).to receive(:add_to_tree).and_call_original
      expect(association2).to receive(:add_to_tree)
      join_path.add_to_tree({})
    end

    it 'lets the association mutate the tree' do
      posts_join = tree.keys.first
      expect(posts_join.name).to eq(:posts)
    end

    it 'recursively adds to the tree' do
      comments_join = tree.values.first.keys.first
      expect(comments_join.name).to eq(:comments)
    end
  end
end
