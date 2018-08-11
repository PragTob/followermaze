module FollowMe
  # Access to the follower relationships to follow, unfollow a user and retrieve
  # the followers of a user.
  class Relationships
    def initialize
      @followers = {}
    end

    def follow(from, to)
      return if following_self?(from, to)
      followers(to) << from
    end

    def followers(id)
      @followers[id] ||= Set.new
    end

    def unfollow(from, to)
      followers(to).delete from
    end

    private
    def following_self?(from, to)
      from == to
    end
  end
end