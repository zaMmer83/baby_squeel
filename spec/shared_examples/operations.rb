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
