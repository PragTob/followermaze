require 'spec_helper'

RSpec.describe FollowMe::Event::Follow do

  subject(:event) {described_class.new payload, sequence_number, from, to}

  describe '#deliver' do
    include_context 'events'

    it 'adds a follower for the to' do
      expect(relationships).to have_received(:follow).with(from, to)
    end

    it 'sends out a notification to the followed user' do
      expect(user_connections).to have_received(:send_message).with(to, payload)
    end
  end
end