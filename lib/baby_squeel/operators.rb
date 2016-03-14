module BabySqueel
  module Operators
    def self.arel_alias(operator, arel_name)
      define_method operator do |other|
        send(arel_name, other)
      end
    end

    arel_alias :==, :eq
    arel_alias :'!=', :not_eq
    arel_alias :<, :lt
    arel_alias :>, :gt
    arel_alias :<=, :lteq
    arel_alias :>=, :gteq
    arel_alias :=~, :matches
    arel_alias :'!~', :does_not_match

    def op(operator, other)
      Nodes::Operation.new(operator, self, other)
    end
  end
end
