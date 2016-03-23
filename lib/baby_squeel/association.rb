require 'baby_squeel/table'

module BabySqueel
  class AliasingError < StandardError
    MESSAGE =
      'Attempted to alias \'%{association}\' as \'%{alias_name}\', but the ' \
      'association was implicitly joined. Either join the association ' \
      'with `on` or remove the alias.'.freeze

    def initialize(association, alias_name)
      super format(MESSAGE, association: association, alias_name: alias_name)
    end
  end

  class Association < Table
    def initialize(parent, reflection)
      @parent = parent
      @reflection = reflection
      super(@reflection.klass)
    end

    def _arel
      props[:on] ? super : ([*@parent._arel] + join_constraints)
    end

    private

    def join_constraints
      if props[:table].is_a? Arel::Nodes::TableAlias
        raise AliasingError.new(@reflection.name, props[:table].right)
      end

      @reflection.active_record.joins(@reflection.name).join_sources.map do |join|
        props[:join].new(join.left, join.right)
      end
    end

    def spawn
      Association.new(@parent, @reflection).tap do |table|
        table.props = props
      end
    end
  end
end
