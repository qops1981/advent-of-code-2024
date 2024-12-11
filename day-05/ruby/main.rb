#! /usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}

input = File.read("../#{ARGV[0]}").split("\n\n")

class PrintOrder

  def initialize(rules, pages)
    @rules = rules
    @pages = pages
  end

  def valid?(pos = 0, evaluation = true)
    return evaluation unless evaluation
    return true if pos == @pages.size

    evaluation = @rules
      .select {|k,v| k == @pages[pos]}
      .map {|k,v| @pages.index(v)}
      .compact
      .all? {|i| i > pos}

    valid?(pos += 1, evaluation)
  end

  def middle()
    @pages[(@pages.size.to_f / 2).floor]
  end
end

class Day05

  def initialize(input)
    @rules = input.first.split("\n").map {|r| r.split("|")}
    @plist = input.last.split("\n").map {|g| g.split(",")}
  end

  def part_1()
    @plist
      .map {|l| PrintOrder.new(@rules, l)}
      .select {|po| po.valid?}
      .map {|po| po.middle.to_i}
      .sum
  end

  def part_2()

  end

end

puzzel = Day05.new(input.dup)

printf("%s: Day 05, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

# printf("%s: Day 05, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)