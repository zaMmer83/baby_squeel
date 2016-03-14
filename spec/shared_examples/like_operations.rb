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
