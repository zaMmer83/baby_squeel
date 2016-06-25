require 'baby_squeel/table'

module BabySqueel
  class Relation < Table
    attr_accessor :_scope

    def initialize(scope)
      super(scope.arel_table)
      @_scope = scope
    end

    # @override BabySqueel::Table#_table_name
    def _table_name
      _scope.model_name
    end

    # Constructs a new BabySqueel::Association. Raises
    # an exception if the association is not found.
    def association(name)
      if reflection = _scope.reflect_on_association(name)
        Association.new(self, reflection)
      else
        raise AssociationNotFoundError.new(_table_name, name)
      end
    end

    def sift(sifter_name, *args)
      Nodes.wrap _scope.public_send("sift_#{sifter_name}", *args)
    end

    private

    # @override BabySqueel::Table#resolve
    def resolve(name)
      if _scope.column_names.include?(name.to_s)
        self[name]
      elsif _scope.reflect_on_association(name)
        association(name)
      end
    end
  end
end
