module BabySqueel
  class NotFoundError < StandardError
    def initialize(model_name, name)
      super "There is no column or association named '#{name}' for #{model_name}."
    end
  end

  class AssociationNotFoundError < StandardError
    def initialize(model_name, name)
      super "Association named '#{name}' was not found for #{model_name}."
    end
  end

  class AssociationAliasingError < StandardError
    MESSAGE =
      'Attempted to alias \'%{association}\' as \'%{alias_name}\', but the ' \
      'association was implicitly joined. Either join the association ' \
      'with `on` or remove the alias.'.freeze

    def initialize(association, alias_name)
      super format(MESSAGE, association: association, alias_name: alias_name)
    end
  end
end
