# Props to Arel Helpers
# https://github.com/camertron/arel-helpers/blob/master/lib/arel-helpers/join_association.rb
#
# This is really, really ugly.
#
module BabySqueel
  class JoinDependency
    def initialize(scope, reflection, join_type)
      @scope = scope
      @reflection = reflection
      @join_type = join_type
    end

    if ::ActiveRecord::VERSION::MAJOR > 4
      def constraints
        dependency.join_constraints([], @join_type).flat_map(&:joins)
      end
    elsif ::ActiveRecord::VERSION::STRING >= '4.2.0'
      def constraints
        dependency.join_constraints([]).flat_map do |constraint|
          constraint.joins.map { |join| rebuild join }
        end
      end
    elsif ::ActiveRecord::VERSION::STRING >= '4.1.0'
      def constraints
        dependency.join_constraints([]).flat_map { |join| rebuild join }
      end
    else
      def constraints
        manager = Arel::SelectManager.new(@scope)

        dependency.join_associations.each do |assoc|
          assoc.join_type = @join_type
          assoc.join_to(manager)
        end

        manager.join_sources
      end
    end

    private

    def rebuild(join)
      @join_type.new(join.left, join.right)
    end

    def dependency
      ::ActiveRecord::Associations::JoinDependency.new(
        @reflection.active_record,
        [@reflection.name],
        []
      )
    end
  end
end
