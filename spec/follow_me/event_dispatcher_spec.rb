require 'spec_helper'

RSpec.describe FollowMe::EventDispatcher do
  subject(:event_dispatcher) {described_class.new event_store,
                                                  user_connections,
                                                  relationships}
  let(:user_connections) {double 'user_connections'}
  let(:relationships) {double 'user_relationships'}
  let(:event_store) {double 'event store', store: true, next: unordered_event}
  let(:event_payload) {"#{sequence_number}|#{event_type}|60|50"}
  let(:sequence_number) {1}
  let(:event_type) {'F'}
  let(:event) {double 'event', deliver: true, sequence_number: sequence_number}
  let(:unordered_event) {double 'unordered',
                                sequence_number: 77,
                                deliver: true}

  describe 'initialization' do
    it 'is initialized with a sequence number of 1' do
      expect(event_dispatcher.current_sequence_number).to eq 1
    end
  end

  describe '#process' do

    before :each do
      allow(FollowMe::Event).to receive_messages create_from: event
    end

    describe 'event with a current sequence number' do
      let(:sequence_number) {1}

      it 'dispatches the event' do
        event_dispatcher.process event_payload
        expect(event).to have_received :deliver
      end

      it 'changes the current sequence number' do
        expect do
          event_dispatcher.process event_payload
        end.to change {event_dispatcher.current_sequence_number}.by(1)
      end

      describe 'following up on the current event' do
        let(:next_event) {double 'order',
                                     sequence_number: sequence_number + 1,
                                     deliver: true}

        describe 'the next event is in order' do
          before :each do
            allow(event_store).to receive(:next).and_return(next_event,
                                                            unordered_event)
            allow(event_store).to receive(:retrieve_next).and_return(next_event,
                                                                unordered_event)
            event_dispatcher.process event_payload
          end

          it 'processes the next event' do
            expect(next_event).to have_received :deliver
          end

          it 'increases the sequence number' do
            expect(event_dispatcher.current_sequence_number).to eq 3
          end

          it 'does not touch the event which is out of order' do
            expect(unordered_event).not_to have_received :deliver
          end
        end

        describe 'the next event is out of order' do
          before :each do
            allow(event_store).to receive(:next).and_return(unordered_event)

            event_dispatcher.process event_payload
          end

          it 'does not touch the out of order event' do
            expect(unordered_event).not_to have_received :deliver
          end
        end

        describe 'the next event is nil' do
          before :each do
            allow(event_store).to receive(:next).and_return(nil)
          end

          it 'does not raise an error' do
            expect do
              event_dispatcher.process event_payload
            end.not_to raise_error
          end
        end
      end
    end

    describe 'event with an out of order sequence number' do
      let(:sequence_number) {44}

      it 'stores the event' do
        event_dispatcher.process event_payload
        expect(event_store).to have_received :store
      end

      it 'does not touch the current sequence number' do
        expect do
          event_dispatcher.process event_payload
        end.not_to change {event_dispatcher.current_sequence_number}
      end
    end
  end
end