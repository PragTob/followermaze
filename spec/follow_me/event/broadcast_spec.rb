require 'spec_helper'

RSpec.describe FollowMe::Event::Broadcast do
  subject(:event) {described_class.new payload, sequence_number}

  describe '#deliver' do
    include_context 'events'

    it 'sends a message to everyone' do
      expect(user_connections).to have_received(:send_all).with(payload)
    end
  end
end