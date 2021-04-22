require_relative "attribute"

module BabySqueel
  module Queryable
    def _model
      raise NotImplementedError
    end

    def _alias_name
      raise NotImplementedError
    end

    # TODO: Better error
    def assoc(name, alias_name = nil)
      if reflection = _model.reflect_on_association(name)
        Association.new(self, reflection, alias_name: alias_name)
      else
        raise "Can't join '#{_model}' to association named '#{name}'"
      end
    end

    private

    def respond_to_missing?(name, *)
      _model.column_names.include?(name.to_s) || super
    end

    # TODO: Raise on wrong number of arguments
    # TODO: Is it terrible to extend an instance?
    def method_missing(name, *)
      if _model.column_names.include?(name.to_s)
        attribute = _scope.arel_table[name]
        attribute.extend Attribute
        attribute
      else
        super
      end
    end
  end
end
