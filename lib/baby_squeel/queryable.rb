require_relative "operators"

module BabySqueel
  module Queryable
    # TODO: Better error
    # Get a reference to an association
    def assoc(name, alias_name = nil)
      if reflection = _model.reflect_on_association(name)
        Association.new(
          reflection: reflection,
          foreign_table: _table,
          alias_name: alias_name
        )
      else
        raise "Can't join '#{_model}' to association named '#{name}'"
      end
    end

    def _model # :nodoc:
      raise NotImplementedError
    end

    def _table # :nodoc:
      _model.arel_table
    end

    private

    def respond_to_missing?(name, *)
      _model.column_names.include?(name.to_s) || super
    end

    # TODO: Raise on wrong number of arguments
    # TODO: Is it terrible to extend an instance?
    def method_missing(name, *)
      if _model.column_names.include?(name.to_s)
        attribute = _table[name]
        attribute.extend Operators
        attribute
      else
        super
      end
    end
  end
end
