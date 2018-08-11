require 'spec_helper'

RSpec.describe FollowMe::Event::PrivateMessage do
  subject(:event) {described_class.new payload, sequence_number, from, to}

  describe '#deliver' do
    include_context 'events'

    it 'sends a message to the to person' do
      expect(user_connections).to have_received(:send_message).with(to, payload)
    end
  end
end