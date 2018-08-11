module Sorted
  module Algorithm
    class LinearIndexSearch
      def find_index_for(object, array)
        index = array.find_index {|element| object <= element}
        index = array.size unless index
        index
      end
    end
  end
end