module BabySqueel
  module ActiveRecord
    # This allow us to prevent duplicate nodes from being joined
    # Normal association names like :author can be compared to
    # BabySqueel::Nodes::InnerJoin and deduped.
    class JoinsValues < Array
      def +(additions)
        values = JoinsValues.new(to_a)
        values.add!(additions)
        values
      end

      def add!(additions, &block)
        additions.each do |addition|
          if index = find_same_index(addition)
            # This addition is a duplicate, replace the existing
            # item if it isn't a BabySqueel join node
            self[index] = addition unless node?(self[index])
          else
            self << addition
          end
        end
        self
      end

      private

      def find_same_index(a)
        find_index do |b|
          node?(a) && a.eql?(b) || node?(b) && b.eql?(a)
        end
      end

      def node?(item)
        item.respond_to? :same_association?
      end
    end
  end
end
