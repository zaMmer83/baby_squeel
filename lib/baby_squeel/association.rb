require 'baby_squeel/table'

module BabySqueel
  class AliasingError < StandardError
    def initialize(association, alias_name)
      super(<<-EOMSG.strip_heredoc.tr("\n", ' '))
        Attempted to alias '#{association}' as '#{alias_name}', but the
        association was implicitly joined. Either join the association with `on`
        or remove the alias.
      EOMSG
    end
  end

  class Association < Table
    def initialize(parent, reflection)
      @parent = parent
      @reflection = reflection
      super(@reflection.klass)
    end

    def _arel
      return super if props[:on] # they're doing an explicit join

      [*@parent._arel] + join_constraints.flat_map do |constraint|
        constraint.joins.map do |join|
          props[:join].new(join.left, join.right)
        end
      end
    end

    private

    def join_constraints
      if props[:table].is_a? Arel::Nodes::TableAlias
        raise AliasingError.new(@reflection.name, props[:table].right)
      end

      ::ActiveRecord::Associations::JoinDependency.new(
        @reflection.active_record,
        [@reflection.name],
        []
      ).join_constraints([])
    end

    def spawn
      Association.new(@parent, @reflection).tap do |table|
        table.props = props
      end
    end
  end
end
