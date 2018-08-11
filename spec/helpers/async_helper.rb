# Used here to wait for messages to arrive (based on thread scheduling etc)
# and to avoid sleeps etc. there
#
# taken from: https://gist.github.com/mattwynne/1228927 with slight adjutemnts
# from another project of mine.
#
# usage:
# it "should return a result of 5" do
#   eventually { expect(long_running_thing.result).to eq(5) }
# end
module AsyncHelper
  def eventually(options = {})
    timeout = options[:timeout] || 2
    interval = options[:interval] || 0.1
    time_limit = Time.now + timeout
    loop do
      begin
        yield
      rescue Exception => error
      end
      return if error.nil?
      raise error if Time.now >= time_limit
      sleep interval
    end
  end
end