require 'forwardable'

require_relative 'sorted/algorithm/linear_index_search'
require_relative 'sorted/algorithm/binary_index_search'
require_relative 'sorted/queue'

if RUBY_ENGINE == 'jruby'
  require 'java'
  require_relative 'sorted/java/priority_queue'
end