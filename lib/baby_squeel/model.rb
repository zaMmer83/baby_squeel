module BabySqueel
  module Model
    def as(name)
      arel_table.as(name)
    end

    def query(&block)
      query = Query.new(all)

      if block.arity.zero?
        query.instance_eval(&block)
      else
        query.instance_exec(query, &block)
      end

      query._scope
    end
  end
end
