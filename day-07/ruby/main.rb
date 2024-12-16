#! /usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction     => false
}

require 'pp'
require 'thread/pool'

input = File.read("../#{ARGV[0]}").split("\n")

class Calibration

  def initialize(test_value, numbers, operators)
    @test      = test_value.to_i
    @numbers   = numbers.split(/\s/).map(&:to_i)
    @operators = operators.repeated_permutation(@numbers.size - 1).to_a
  end

  def calculate(opos, acc = @numbers.first, npos = 1, oepos = 0)
    return acc if acc > @test || npos >= @numbers.size

    case @operators[opos][oepos]
    when '+'
      acc += @numbers[npos]
    when '*'
      acc *= @numbers[npos]
    when '||'
      acc = "#{acc}#{@numbers[npos]}".to_i
    end

    calculate(opos, acc, npos += 1, oepos += 1)
  end

  def valid?()
    ! @operators.detect.with_index {|o, i| calculate(i) == @test}.nil?
  end

end

class Day07

  def initialize(input)
    @inputs = input.map(&:chomp).map {|i| i.split(/: /)}
  end

  def part_1()
    @inputs.map {|i| Calibration.new(i[0], i[1], ['+', '*']).valid? ? i[0].to_i : nil}.compact.sum
  end

  def part_2()
    @inputs.map {|i| Calibration.new(i[0], i[1], ['+', '*', '||']).valid? ? i[0].to_i : nil}.compact.sum
  end

end

puzzel = Day07.new(input.dup)

printf("%s: Day 07, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 07, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)
