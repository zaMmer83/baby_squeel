shared_examples_for 'join equality' do
  let(:posts)      { Post.arel_table }
  let(:authors)    { Author.arel_table }

  let(:expr) {
    Arel::Nodes::On.new(
      authors[:id].eq(posts[:author_id])
    )
  }

  describe '#same_association?' do
    subject {
      described_class.new(authors, expr, :author)
    }

    it 'can be equal to a symbol' do
      is_expected.to be_same_association(:author)
    end

    it 'can be equal to a hash with empty values' do
      is_expected.to be_same_association(author: {})
    end

    it 'can be equal to an array of symbols' do
      is_expected.to be_same_association([:author])
    end

    it 'can be equal to an array of hashes' do
      is_expected.to be_same_association([{ author: {} }])
    end

    it 'can be equal to an Arel::Nodes::InnerJoin' do
      is_expected.to be_same_association(equivalent_node.new(authors, expr))
    end

    it 'can be equal to a BabySqueel::Nodes::InnerJoin' do
      is_expected.to be_same_association(described_class.new(authors, expr, nil))
    end

    describe 'nested joins' do
      subject { described_class.new(authors, expr, { author: :posts }) }

      it 'can be equal to a hash' do
        is_expected.to be_same_association(author: :posts)
      end

      it 'can be equal to a hash with empty values' do
        is_expected.to be_same_association(author: { posts: {} })
      end

      it 'can be equal to an array of hashes' do
        is_expected.to be_same_association([{ author: :posts }])
      end
    end
  end
end
