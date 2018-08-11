module Sorted
  # A queue that keeps its elements sorted upon insert to quickly retrieve
  # the smallest element. The interface is inspired by Java's PriorityQueue.
  #
  # The algorithm to find the right insertion point can be adjusted through an
  # algorithm implementation.
  class Queue
    def initialize(index_finder = Sorted::Algorithm::BinaryIndexSearch.new)
      @array        = []
      @index_finder = index_finder
    end

    def insert(object)
      index = @index_finder.find_index_for(object, @array)
      @array.insert(index, object)
    end

    def peek
      @array.first
    end

    def poll
      @array.shift
    end

    def size
      @array.size
    end

    def empty?
      @array.empty?
    end
  end
end