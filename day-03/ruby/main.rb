#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}")

class Memory

  def initialize(raw_memory)
    @instructions = raw_memory.scan(/(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))/)
  end

  def calc_all
    @instructions
      .reject {|i| ["do()", "don't()"].include?(i) }
      .map    {|i| a, b = i.first.scan(/\d+/); a.to_i * b.to_i }
      .sum
  end

  def calc_instructions(is_enabled = true, acc = 0)
    return acc if @instructions.empty?

    i = @instructions.shift.first

    case i
    when "do()"
      is_enabled = true
    when "don't()"
      is_enabled = false
    else
      a, b  = i.scan(/\d+/)
      acc  += a.to_i * b.to_i if is_enabled == true
    end

    calc_instructions(is_enabled, acc)
  end
end

class Day03

  def initialize(input)
    @input = input.chomp
  end

  def part_1()
    Memory.new(@input).calc_all
  end

  def part_2()
    Memory.new(@input).calc_instructions
  end

end

puzzel = Day03.new(input.dup)

printf("%s: Day 03, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 03, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)