module BabySqueel
  class CalculationProxy # :nodoc:
    # This is what is commonly referred to as a hack!
    #
    # In Active Record 4, the calculations methods don't technically
    # accept Arel nodes. This is a proxy around Arel to make it work!
    #
    # Active Record 5 happily accepts Arel nodes, though. So in that case,
    # CalculationProxy.wrap will just return the Arel node.

    if ActiveRecord::VERSION::MAJOR < 5
      def self.wrap(node); new(node); end
    else
      def self.wrap(node); node; end
    end

    def initialize(node)
      @node = node
    end

    def type_cast_from_database(value)
      value
    end

    def unwrap
      @node
    end

    # Plucking will call #to_s on this object.
    # See: ActiveRecord::Relation::Calculations#pluck
    alias to_s unwrap
  end
end
