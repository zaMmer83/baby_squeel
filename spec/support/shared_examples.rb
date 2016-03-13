RSpec.shared_examples_for 'a node with operations' do
  describe '#==' do
    it 'translates to sql' do
      expect(attribute == 1).to produce_sql("#{attribute_sql} = 1")
    end
  end

  describe '#!=' do
    it 'translates to sql' do
      expect(attribute != 1).to produce_sql("#{attribute_sql} != 1")
    end
  end

  describe '#<' do
    it 'translates to sql' do
      expect(attribute < 1).to produce_sql("#{attribute_sql} < 1")
    end
  end

  describe '#>' do
    it 'translates to sql' do
      expect(attribute > 1).to produce_sql("#{attribute_sql} > 1")
    end
  end

  describe '#<=' do
    it 'translates to sql' do
      expect(attribute <= 1).to produce_sql("#{attribute_sql} <= 1")
    end
  end

  describe '#>=' do
    it 'translates to sql' do
      expect(attribute >= 1).to produce_sql("#{attribute_sql} >= 1")
    end
  end

  describe '#+' do
    it 'translates to sql' do
      expect(attribute + 1).to produce_sql("#{attribute_sql} + 1")
    end
  end

  describe '#-' do
    it 'translates to sql' do
      expect(attribute - 1).to produce_sql("#{attribute_sql} - 1")
    end
  end

  describe '#*' do
    it 'translates to sql' do
      expect(attribute * 1).to produce_sql("#{attribute_sql} * 1")
    end
  end

  describe '#/' do
    it 'translates to sql' do
      expect(attribute / 1).to produce_sql("#{attribute_sql} / 1")
    end
  end

  describe '#op' do
    it 'produces sql for a given operator' do
      expect(attribute.op(:%, 1)).to produce_sql("#{attribute_sql} % 1")
    end
  end
end

RSpec.shared_examples_for 'a node with like operations' do
  describe '#=~' do
    it 'translates to sql' do
      sql = "#{attribute_sql} LIKE 'test%'"
      expect(attribute =~ 'test%').to produce_sql(sql)
    end
  end

  describe '#!~' do
    it 'translates to sql' do
      sql = "#{attribute_sql} NOT LIKE 'test%'"
      expect(attribute !~ 'test%').to produce_sql(sql)
    end
  end
end
