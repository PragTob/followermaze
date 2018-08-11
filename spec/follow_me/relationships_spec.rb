require 'spec_helper'

RSpec.describe FollowMe::Relationships do
  subject(:relationships) {described_class.new}
  let(:popular_person) {20}

  describe 'one follower' do
    let(:follower) {10}

    before :each do
      relationships.follow(follower, popular_person)
    end

    it 'adds the user popular_person the #followers' do
      expect_followers.to contain_exactly follower
    end

    describe '#unfollow' do
      it 'can unfollow the user' do
        relationships.unfollow(follower, popular_person)
        expect_followers.to be_empty
      end

      it 'does not crash when trying to unfollow a non existing user' do
        expect do
          relationships.unfollow(follower, 1337)
        end.not_to raise_error
      end
    end

    describe 'following yourself' do
      let(:follower) {popular_person}

      it 'does not make sense and does nothing' do
        expect_followers.to be_empty
      end
    end

    describe 'following the same person again' do
      it 'does not duplicate the follower' do
        relationships.follow(follower, popular_person)
        expect_followers.to contain_exactly follower
      end
    end
  end

  describe 'multiple followers' do
    let(:followers) {[1, 4, 7, 102, 3]}

    before :each do
      followers.each {|follower| relationships.follow follower, popular_person}
    end

    it 'notices all the followers' do
      expect_followers.to match_array followers
    end
  end

  def expect_followers
    expect(relationships.followers(popular_person))
  end
end