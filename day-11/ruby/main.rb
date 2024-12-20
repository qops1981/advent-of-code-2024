#! /usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction     => false
}

require 'pp'
require 'set'
require 'thread/pool'

input = File.read("../#{ARGV[0]}").split(/\n|\s/)

class Stones

  attr_reader :arrangement

  def initialize(arrangement)
    @arrangement = arrangement
  end

  def blink(n = 1)
    ledger = Hash.new { |h, k|   h[k]  = 0 }
    @arrangement.each { |a| ledger[a] += 1 }
    transform(n, ledger)
  end

  private

  def transform(blinks, ledger)
    return ledger if blinks == 0

    neo = Hash.new { |h, k| h[k] = 0 }

    ledger.each do |a, c|
      case
      when a == "0"
        neo["1"] += c
      when a.size.even?
        hs = a.size / 2
        neo[a[...hs].to_i.to_s] += c
        neo[a[hs.. ].to_i.to_s] += c
      else
        neo[(a.to_i*2024).to_s] += c
      end
    end

    transform(blinks -= 1, neo)
  end
end

class Day11

  def initialize(input)
    @input = input.map(&:chomp)
  end

  def part_1()
    Stones.new(@input).blink(25).values.sum
  end

  def part_2()
    Stones.new(@input).blink(75).values.sum
  end

end

puzzel = Day11.new(input.dup)

printf("%s: Day 11, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 11, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)
