module FollowMe
  module Event
    # Base class for events that have both a from and a to
    class FromTo < Base
      attr_reader :from, :to

      def initialize(payload, sequence_number, from, to)
        @from = from
        @to   = to
        super(payload, sequence_number)
      end
    end
  end
end