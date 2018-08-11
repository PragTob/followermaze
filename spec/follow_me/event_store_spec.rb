require 'spec_helper'

RSpec.describe FollowMe::EventStore do
  subject(:event_store) {described_class.new}

  it 'starts out empty' do
    expect(subject).to be_empty
  end

  describe '#store' do
    let(:event) {create_event(42)}

    before :each do
      subject.store event
    end

    it 'can see what the #next event is' do
      expect(subject.next).to eq event
    end

    describe '#retrieve_next' do
      it 'returns the next event' do
        expect(subject.retrieve_next).to eq event
      end

      it 'is empty after retrieving the next event' do
        subject.retrieve_next
        expect(subject).to be_empty
      end
    end
  end

  describe 'storing multiple items' do
    let(:sequence_numbers) {[1, 5, 6, 9, 22, 67, 100]}
    let(:events) {sequence_numbers.shuffle.map {|i| create_event i}}

    before :each do
      events.each {|event| subject.store event}
    end

    it 'is not empty' do
      expect(subject).not_to be_empty
    end

    it 'pops the events of in a sorted sequence' do
      events = []
      until subject.empty?
        events << subject.retrieve_next
      end
      event_sequence = events.map(&:sequence_number)
      expect(event_sequence).to eq sequence_numbers
    end
  end

  def create_event(sequence_number)
    FollowMe::Event::Base.new 'dummy_payload', sequence_number
  end
end