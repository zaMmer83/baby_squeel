require_relative "operators"

module BabySqueel
  class SQL
    def initialize(connection)
      @connection = connection
    end

    def raw(value)
      Arel.sql(value)
    end

    def quote(value)
      raw @connection.quote(value)
    end

    private

    def respond_to_missing?(*)
      true
    end

    def method_missing(name, *args)
      function = Arel::Nodes::NamedFunction.new(name.to_s.upcase, args)
      function.extend Operators
      function
    end
  end
end
