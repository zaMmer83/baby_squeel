require_relative "operators"

module BabySqueel
  class Table
    attr_reader :_table

    def initialize(name, alias_name: nil)
      @_table = Arel::Table.new(name)
      @_table.table_alias = alias_name
    end

    private

    def respond_to_missing?(*)
      true
    end

    def method_missing(name, *args)
      if args.empty?
        attribute = _table[name]
        attribute.extend Operators
        attribute
      else
        raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
      end
    end
  end
end
