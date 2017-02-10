module BabySqueel
  class CalculationProxy # :nodoc:
    # This is what is commonly referred to as a hack!
    #
    # In Active Record 4, the calculations methods don't
    # technically accept arel. Active Record will call #to_s on
    # whatever you pass it. Luckily, we can get around that by
    # having #to_s just return the node.
    #
    # Active Record 5 happily accepts arel, though. So in that case,
    # CalculationProxy.wrap will just return the node.
    #
    # See:
    #   - ActiveRecord::Relation::Calculations#pluck
    #   - ActiveRecord::Relation::Calculations#aggregate_column

    if ActiveRecord::VERSION::MAJOR < 5
      def self.wrap(node); new(node); end
    else
      def self.wrap(node); node; end
    end

    def initialize(node)
      @node = node
    end

    def to_s
      @node
    end
  end
end
