# ruby-prof showed that one of the spot where most time is spent is
# number comparisons and sorting, so this tries to replicate the overall
# scenario using the first 100 000 sequence ids from the benchmark program
# as well as constantly polling the newest out.
#
# Currently Binary Search is the fastest on JRuby and CRUby.
#
# This is a current result using JRuby:
#
# $ ruby benchmark/sorted_queue.rb
# Calculating -------------------------------------
# linear                  1.000  i/100ms
# binary                  1.000  i/100ms
# Java Priority Queue     1.000  i/100ms
# -------------------------------------------------
# linear                  9.940  (± 0.0%) i/s -     50.000
# binary                  14.893  (± 0.0%) i/s -     75.000
# Java Priority Queue     10.036  (± 0.0%) i/s -     51.000


require_relative '../lib/sorted'
require 'benchmark/ips'

NUMBER_FILE = File.dirname(File.expand_path(__FILE__)) +
              '/first_100_000_sequence_ids'
FIRST_100_000_SEQUENCES = File.read(NUMBER_FILE).split(',').map(&:to_i).freeze

linear_queue = Sorted::Queue.new Sorted::Algorithm::LinearIndexSearch.new
binary_queue = Sorted::Queue.new Sorted::Algorithm::BinaryIndexSearch.new

queues = [[linear_queue, 'linear'], [binary_queue, 'binary']]

if RUBY_ENGINE == 'jruby'
  java_priority_queue = Sorted::Java::PriorityQueue.new
  queues << [java_priority_queue, 'Java Priority Queue']
end

def process_100_000_items(queue)
  current_sequence_number = 1
  FIRST_100_000_SEQUENCES.each do |sequence_number|
    if current_sequence_number == sequence_number
      current_sequence_number += 1 # is dropped (instant event delivery)
      while queue.peek && queue.peek == current_sequence_number
        queue.poll
        current_sequence_number += 1
      end
    else
      queue.insert sequence_number
    end
  end
end

Benchmark.ips do |benchmark|
  queues.each do |queue, queue_name|
    benchmark.report(queue_name) do
      process_100_000_items queue
    end
  end
end

