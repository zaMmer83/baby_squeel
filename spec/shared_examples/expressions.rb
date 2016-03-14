RSpec.shared_examples_for 'a node with expressions' do
  describe '#average' do
    it 'includes order predications' do
      expect(attribute.average.desc).to produce_sql("AVG(#{attribute_sql}) DESC")
    end
  end

  describe '#count' do
    it 'includes order predications' do
      expect(attribute.count.desc).to produce_sql("COUNT(#{attribute_sql}) DESC")
    end
  end

  describe '#extract' do
    it 'includes order predications' do
      sql = "EXTRACT(HOUR FROM #{attribute_sql}) DESC"
      expect(attribute.extract('hour').desc).to produce_sql(sql)
    end
  end

  describe '#maximum' do
    it 'includes order predications' do
      expect(attribute.maximum.desc).to produce_sql("MAX(#{attribute_sql}) DESC")
    end
  end

  describe '#minimum' do
    it 'includes order predications' do
      expect(attribute.minimum.desc).to produce_sql("MIN(#{attribute_sql}) DESC")
    end
  end

  describe '#sum' do
    it 'includes order predications' do
      expect(attribute.sum.desc).to produce_sql("SUM(#{attribute_sql}) DESC")
    end
  end
end
