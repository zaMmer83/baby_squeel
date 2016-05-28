require 'spec_helper'

if ENV['COMPAT'] == '1'
  BabySqueel.enable_compatibility!

  describe BabySqueel::Compat do
    describe '#select' do
      let(:sql) { /SELECT ("posts"."id"|id) FROM/ }

      it 'allows the use of the DSL' do
        relation = Post.select { id }
        expect(relation).to match_sql(sql)
      end

      it 'does not break default behavior' do
        relation = Post.select :id
        expect(relation).to match_sql(sql)
      end

      it 'mitigates the problem of Array#select when given arity' do
        values = Post.select { |post| post.id }
        expect(values).not_to respond_to(:to_sql)
      end
    end

    describe '#joins' do
      let(:sql) {
        /INNER JOIN "authors" ON "authors"."id" = "posts"."author_id"/
      }

      it 'allows the use of the DSL' do
        relation = Post.joins { author }
        expect(relation).to match_sql(sql)
      end

      it 'does not break default behavior' do
        relation = Post.joins :author
        expect(relation).to match_sql(sql)
      end
    end

    describe '#order' do
      let(:sql) { /ORDER BY "posts".("id"|id) ASC/ }

      it 'allows the use of the DSL' do
        relation = Post.order { id.asc }
        expect(relation).to match_sql(sql)
      end

      it 'does not break default behavior' do
        relation = Post.order :id
        expect(relation).to match_sql(sql)
      end
    end

    describe '#group' do
      let(:sql) { /GROUP BY ("posts"."author_id"|author_id)/ }

      it 'allows the use of the DSL' do
        relation = Post.select('COUNT("posts"."id")').group { author_id }
        expect(relation).to match_sql(sql)
      end

      it 'does not break default behavior' do
        relation = Post.select('COUNT("posts"."id")').group(:author_id)
        expect(relation).to match_sql(sql)
      end
    end

    describe '#having' do
      let(:sql) { /HAVING(.+)COUNT\("posts"."id"\) > 5/ }

      it 'allows the use of the DSL' do
        relation = Post.select('COUNT("posts"."id")')
                       .group(:author_id)
                       .having { id.count > 5 }

        expect(relation).to match_sql(sql)
      end

      it 'does not break default behavior' do
        relation = Post.select('COUNT("posts"."id")')
                       .group(:author_id)
                       .having('COUNT("posts"."id") > 5')

        expect(relation).to match_sql(sql)
      end
    end

    describe '#where' do
      let(:sql) { /WHERE "posts"."title" = 'test'/ }

      it 'allows the use of the DSL' do
        relation = Post.where { title == 'test' }
        expect(relation).to match_sql(sql)
      end

      it 'does not break default behavior' do
        relation = Post.where(title: 'test')
        expect(relation).to match_sql(sql)
      end
    end
  end
end
