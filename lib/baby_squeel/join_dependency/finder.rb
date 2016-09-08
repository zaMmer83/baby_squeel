module BabySqueel
  module JoinDependency
    class Finder # :nodoc:
      attr_reader :join_dependency

      def initialize(join_dependency)
        @join_dependency = join_dependency
      end

      def find_alias(reflection)
        join_association = find_association(reflection)
        join_association.tables.first if join_association
      end

      private

      def find(&block)
        deeply_find(join_dependency.join_root, &block)
      end

      def find_association(reflection)
        find { |assoc| reflections_equal?(assoc.reflection, reflection) }
      end

      def deeply_find(root, &block)
        root.children.each do |assoc|
          found = assoc if yield assoc
          found ||= deeply_find(assoc, &block)
          return found if found
        end

        nil
      end

      def reflections_equal?(a, b)
        a.name == b.name && a.klass == b.klass
      end
    end
  end
end
