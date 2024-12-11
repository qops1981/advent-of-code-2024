#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class Day01

  def initialize(values)
    @pairs = values.map {|l| l.chomp.split(/\s+/).map(&:to_i) }
    @left, @right = @pairs.transpose
  end

  def part_1()
    @left.sort.zip(@right.sort).map {|a, b| (a - b).abs}.sum
  end

  def part_2()
    @left.map {|v| v * @right.count(v)}.sum
  end

end

puzzel = Day01.new(input.dup)

printf("%s: Day 01, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 01, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)

