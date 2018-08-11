require 'spec_helper'

RSpec.describe FollowMe::Event do
  subject(:event) {event_creator.create_from event_payload}

  let(:event_creator) {FollowMe::Event}
  let(:event_payload) {"#{sequence_number}|#{type}|#{from}|#{to}"}
  let(:sequence_number) {3}
  let(:from) {60}
  let(:to) {50}

  shared_examples_for 'basic_event' do |clazz|
    it "produces an event of class #{clazz}" do
      expect(event).to be_instance_of clazz
    end

    its(:sequence_number) {is_expected.to eq sequence_number}
  end

  shared_examples_for 'from_to_event' do |clazz|
    it_behaves_like 'basic_event', clazz

    its(:from) {is_expected.to eq(from)}
    its(:to) {is_expected.to eq(to)}

  end

  describe FollowMe::Event::Follow do
    let(:type) {'F'}
    it_behaves_like 'from_to_event', described_class
  end

  describe FollowMe::Event::Unfollow do
    let(:type) {'U'}
    it_behaves_like 'from_to_event', described_class
  end

  describe FollowMe::Event::Broadcast do
    let(:event_payload) {"#{sequence_number}|#{type}"}
    let(:type) {"B\n"}

    it_behaves_like 'basic_event', described_class
  end

  describe FollowMe::Event::PrivateMessage do
    let(:type) {'P'}
    it_behaves_like 'from_to_event', described_class
  end

  describe FollowMe::Event::StatusUpdate do
    let(:event_payload) {"#{sequence_number}|#{type}|#{from}"}
    let(:type) {'S'}

    it_behaves_like 'basic_event', described_class
    its(:from) {is_expected.to eq from}
  end

  it 'raises an error on an unknown event type' do
    expect do
      FollowMe::Event.create_from '1|A'
    end.to raise_error FollowMe::Event::UnknownEventError
  end
end