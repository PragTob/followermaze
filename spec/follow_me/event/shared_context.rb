shared_context 'events' do
  let(:payload) {'payload'} # not the one for the event, but does not matter
  let(:from) {60}
  let(:to) {70}
  let(:sequence_number) {1}
  let(:user_connections) {double 'user_connections', send_message: true,
                                                     send_all: true}
  let(:relationships) {double 'relationships', follow: true,
                                               unfollow: true,
                                               followers: followers}
  let(:followers) {[]}

  before :each do
    subject.deliver user_connections, relationships
  end

end