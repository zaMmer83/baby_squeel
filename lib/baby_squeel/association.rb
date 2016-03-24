require 'baby_squeel/table'

module BabySqueel
  class Association < Table
    class AliasingError < StandardError
      MESSAGE =
        'Attempted to alias \'%{association}\' as \'%{alias_name}\', but the ' \
        'association was implicitly joined. Either join the association ' \
        'with `on` or remove the alias.'.freeze

      def initialize(association, alias_name)
        super format(MESSAGE, association: association, alias_name: alias_name)
      end
    end

    attr_reader :_reflection

    def initialize(parent, reflection)
      @parent = parent
      @_reflection = reflection
      super(@_reflection.klass)
    end

    def _arel(associations = [])
      if _on
        super
      elsif _table.is_a? Arel::Nodes::TableAlias
        raise AliasingError.new(_reflection.name, _table.right)
      else
        @parent._arel([self, *associations])
      end
    end
  end
end
