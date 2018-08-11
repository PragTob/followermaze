require 'spec_helper'

RSpec.describe Sorted::Queue do
  shared_examples_for 'sorted queue' do
    it 'is initially empty' do
      expect(subject).to be_empty
    end

    it 'inserts an element just fine' do
      subject.insert 1
      expect(subject.poll).to eq 1
    end

    describe 'with some elements inserted' do
      let(:array) {[1, 2, 3, 7, 15, 20, 34, 100]}

      before :each do
        array.shuffle.each { |each| subject.insert each }
      end

      it 'has the right #peek' do
        expect(subject.peek).to eq 1
      end

      describe '#poll' do
        it 'removes the element from the array' do
          subject.poll
          expect(subject.size).to eq (array.size - 1)
        end

        it 'retrieves the first element' do
          expect(subject.poll).to eq 1
        end

        describe 'poll all items' do

          let!(:polled_items) { array.map { subject.poll } }

          it 'returns elements in the right order' do
            expect(polled_items).to eq array
          end

          it 'empties the subject' do
            expect(subject).to be_empty
          end
        end
      end
    end
  end

  describe 'Sorted Queue with Linear Index Search' do
    subject {Sorted::Queue.new(Sorted::Algorithm::LinearIndexSearch.new)}
    it_behaves_like 'sorted queue'
  end

  describe 'Sorted Queue with Binary Index Search' do
    subject {Sorted::Queue.new(Sorted::Algorithm::BinaryIndexSearch.new)}
    it_behaves_like 'sorted queue'
  end

  if RUBY_ENGINE == 'jruby'
    describe Sorted::Java::PriorityQueue do
      subject {described_class.new}
      it_behaves_like 'sorted queue'
    end
  end

  describe 'of course the default constructor/algorithm works' do
    subject {Sorted::Queue.new}
    it_behaves_like 'sorted queue'
  end
end