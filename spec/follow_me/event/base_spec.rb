require 'spec_helper'

RSpec.describe FollowMe::Event::Base do
  subject(:event) {described_class.new payload, sequence_number}

  let(:sequence_number) {44}
  let(:payload) {'payload'}

  its(:sequence_number) {is_expected.to eq sequence_number}

  describe 'comparing is done by sequence numbers' do
    it 'is greater than an event with a lower sequence number' do
      other_event = described_class.new payload, 2
      expect(subject).to be > other_event
    end

    it 'is smaller than an event with a bigger sequence number' do
      other_event = described_class.new payload, 104
      expect(subject).to be < other_event
    end
  end
end