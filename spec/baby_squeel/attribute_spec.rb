require 'spec_helper'
require 'baby_squeel/nodes'

describe BabySqueel::Nodes::Attribute do
  let(:column) { :id }

  let(:attribute) {
    BabySqueel::Nodes::Attribute.new(Post.arel_table, column)
  }

  describe '#|' do
  end

  describe '#&' do
  end

  describe '#==' do
    it 'translates to sql' do
      expect(attribute == 1).to produce_sql('"posts"."id" = 1')
    end
  end

  describe '#!=' do
    it 'translates to sql' do
      expect(attribute != 1).to produce_sql('"posts"."id" != 1')
    end
  end

  describe '#<' do
    it 'translates to sql' do
      expect(attribute < 1).to produce_sql('"posts"."id" < 1')
    end
  end

  describe '#>' do
    it 'translates to sql' do
      expect(attribute > 1).to produce_sql('"posts"."id" > 1')
    end
  end

  describe '#<=' do
    it 'translates to sql' do
      expect(attribute <= 1).to produce_sql('"posts"."id" <= 1')
    end
  end

  describe '#>=' do
    it 'translates to sql' do
      expect(attribute >= 1).to produce_sql('"posts"."id" >= 1')
    end
  end

  describe '#=~' do
    let(:column) { :title }

    it 'translates to sql' do
      expect(attribute =~ 'test%').to produce_sql(%("posts"."title" LIKE 'test%'))
    end
  end

  describe '#!~' do
    let(:column) { :title }

    it 'translates to sql' do
      expect(attribute !~ 'test%').to produce_sql(%("posts"."title" NOT LIKE 'test%'))
    end
  end

  describe '#+' do
    it 'translates to sql' do
      expect(attribute + 1).to produce_sql('"posts"."id" + 1')
    end
  end

  describe '#-' do
    it 'translates to sql' do
      expect(attribute - 1).to produce_sql('"posts"."id" - 1')
    end
  end

  describe '#*' do
    it 'translates to sql' do
      expect(attribute * 1).to produce_sql('"posts"."id" * 1')
    end
  end

  describe '#/' do
    it 'translates to sql' do
      expect(attribute / 1).to produce_sql('"posts"."id" / 1')
    end
  end

  describe '#op' do
    it 'produces sql for a given operator' do
      expect(attribute.op(:%, 1)).to produce_sql('"posts"."id" % 1')
    end
  end
end
