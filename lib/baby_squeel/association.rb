require 'baby_squeel/table'

module BabySqueel
  class Association < Table
    def initialize(parent, reflection)
      @parent = parent
      @reflection = reflection
      super(@reflection.klass)
    end

    def _arel
      theirs = @parent._arel if @parent.respond_to?(:_arel)

      mine = join_dependency.join_constraints([]).flat_map do |constraint|
        constraint.joins.map do |join|
          @join_type.new(join.left, join.right)
        end
      end

      [*theirs, *mine].uniq
    end

    private

    def join_dependency
      ::ActiveRecord::Associations::JoinDependency.new(
        @reflection.active_record,
        [@reflection.name],
        []
      )
    end

    def spawn
      Association.new(@parent, @reflection)
    end
  end
end
