module BabySqueel
  module Expressions
    def average
      Nodes::Avg.new([self])
    end

    def count(distinct = false)
      Nodes::Count.new([self], distinct)
    end

    def extract(field)
      Nodes::Extract.new([self], field)
    end

    def maximum
      Nodes::Max.new([self])
    end

    def minimum
      Nodes::Min.new([self])
    end

    def sum
      Nodes::Sum.new([self])
    end
  end
end
