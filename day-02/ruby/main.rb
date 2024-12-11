#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class Report

  def initialize(levels)
    @levels = levels.split(/\s+/).map(&:to_i)
  end

  def safe?(levels = @levels)
    diffs = levels.each_cons(2).to_a.map {|a, b| a - b}
    diffs.all? {|v| v >= 1 && v <= 3} || diffs.all? {|v| v <= -1 && v >= -3}
  end

  def dampened_safe?
    (0..@levels.size - 1).any? {|i| safe?(@levels.dup.tap {|l| l.delete_at(i)})}
  end


end

class Day02

  def initialize(values)
    @records = values.map(&:chomp)
  end

  def part_1()
    @records.map {|l| Report.new(l)}.count {|v| v.safe?}
  end

  def part_2()
    @records.map {|l| Report.new(l)}.count {|v| v.dampened_safe?}
  end

end

puzzel = Day02.new(input.dup)

printf("%s: Day 02, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 02, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)