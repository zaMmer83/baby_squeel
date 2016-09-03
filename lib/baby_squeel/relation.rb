require 'baby_squeel/table'

module BabySqueel
  class Relation < Table
    attr_accessor :_scope

    def initialize(scope)
      super(scope.arel_table)
      @_scope = scope
    end

    # Constructs a new BabySqueel::Association. Raises
    # an exception if the association is not found.
    def association(name)
      if reflection = _scope.reflect_on_association(name)
        Association.new(self, reflection)
      else
        not_found_error! name, type: AssociationNotFoundError
      end
    end

    def sift(sifter_name, *args)
      Nodes.wrap _scope.public_send("sift_#{sifter_name}", *args)
    end

    private

    # @override BabySqueel::Table#not_found_error!
    def not_found_error!(name, type: NotFoundError)
      raise type.new(_scope.model_name, name)
    end

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
