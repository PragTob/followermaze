module Sorted
  module Java
    class PriorityQueue
      extend Forwardable

      def_delegators :@priority_queue, :peek, :poll, :size, :empty?

      def initialize
        @priority_queue = java.util.PriorityQueue.new
      end

      def insert(object)
        @priority_queue.add object
      end
    end
  end
end