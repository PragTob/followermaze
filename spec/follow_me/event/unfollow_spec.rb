require 'spec_helper'

RSpec.describe FollowMe::Event::Unfollow do
  subject {described_class.new payload, sequence_number, from, to}

  describe '#deliver' do
    include_context 'events'

    it 'unfollows the user' do
      expect(relationships).to have_received(:unfollow).with(from, to)
    end

    it 'does not notify the unfollowed user' do
      expect(user_connections).not_to have_received(:send_message)
    end
  end
end