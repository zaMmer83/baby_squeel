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

    # Intelligently constructs Arel nodes. There are three outcomes:
    #
    # 1. The user explicitly constructed their join using #on. See BabySqueel::Table#_arel.
    #
    # 2. The user aliased an implicitly joined association. ActiveRecord's join dependency
    #    gives us no way of handling this, so we have to throw an error.
    #
    # 3. The user implicitly joined this association, so we pass this association up the tree
    #    until it hits the top-level BabySqueel::Table. Once it gets there, Arel join nodes
    #    will be constructed.
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
