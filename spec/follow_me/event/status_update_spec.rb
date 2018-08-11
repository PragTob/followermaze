require 'spec_helper'

RSpec.describe FollowMe::Event::StatusUpdate do
  subject(:event) {described_class.new payload, sequence_number, from}

  describe '#deliver' do
    include_context 'events'

    let(:followers) {[1, 4, 6, 7, 8]}

    it 'sends a message to the followers' do
      expect(user_connections).to have_received(:send_message).with(*followers,
                                                                    payload)
    end
  end
end