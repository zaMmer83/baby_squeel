module BabySqueel
  class Resolver
    def initialize(table, strategies, arity_limit: 0)
      @table       = table
      @strategies  = strategies
      @arity_limit = arity_limit
    end

    def resolve(name, *args, &block)
      result = nil

      @strategies.each do |strategy|
        result = send(strategy, name, *args, &block)
        break if result
      end

      result
    end

    def resolve!(name, *args, &block)
      resolve(name, *args, &block) || not_found!(name)
    end

    def resolves?(name)
      @strategies.any? do |strategy|
        send "#{strategy}?", name
      end
    end

    def association_not_found!(name)
      raise AssociationNotFoundError.new(@table._scope.model_name, name)
    end

    def not_found!(name)
      raise NotFoundError.new(@table._scope.model_name, name, @strategies)
    end

    def association?(name)
      !@table._scope.reflect_on_association(name).nil?
    end

    def association(name, *args)
      if args.empty? && !block_given? && association?(name)
        @table.association(name)
      end
    end

    def function?(_name)
      true
    end

    def function(name, *args)
      @table.func(name, *args) if !args.empty? && !block_given?
    end

    def column?(name)
      @table._scope.column_names.include?(name.to_s)
    end

    def column(name, *args)
      @table[name] if args.empty? && !block_given? && column?(name)
    end

    def attribute?(_name)
      true
    end

    def attribute(name, *args)
      @table[name] if args.empty?
    end
  end
end
