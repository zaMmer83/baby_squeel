module BabySqueel
  module Attribute
    def self.register(operator, arel_name)
      define_method operator do |*args|
        send(arel_name, *args)
      end
    end

    register :<, :lt
    register :>, :gt
    register :<=, :lteq
    register :>=, :gteq
    register :==, :eq
    register :'!=', :not_eq
    register :&, :and
    register :|, :or
    register :=~, :matches
    register :'!~', :does_not_match
    register :like, :matches
    register :not_like, :does_not_match
    register :like_any, :matches_any
    register :not_like_any, :does_not_match_any
  end
end
