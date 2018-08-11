module Sorted
  module Algorithm
    class BinaryIndexSearch
      def find_index_for(object, array)
        return 0 if array.empty?
        i_min = 0
        i_max = array.length
        while i_max >= i_min
          i_mid = (i_min + i_max) / 2
          if array[i_mid] && (array[i_mid] < object)
            i_min = i_mid + 1
          else
            i_max = i_mid - 1
          end
        end
        i_min
      end
    end
  end
end