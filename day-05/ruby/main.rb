#! /usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}

input = File.read("../#{ARGV[0]}").split("\n\n")

class Pages

  def initialize(rules, pages)
    @rules = Hash[rules.flat_map {|r| [[r, -1], [r.reverse, 1]]}]
    @pages = pages
  end

  def valid?()
    @pages
      .each_cons(2)
      .to_a
      .each {|c| return false if @rules.key?(c) && @rules[c] == 1}
    return true
  end

  def middle(sort: false)
    @pages.sort! {|x, y| @rules[[x,y]]} if sort
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
      .map    {|pages| Pages.new(@rules, pages)}
      .select {|pages| pages.valid?}
      .map    {|pages| pages.middle.to_i}
      .sum
  end

  def part_2()
    @plist
      .map    {|pages| Pages.new(@rules, pages)}
      .reject {|pages| pages.valid?}
      .map    {|pages| pages.middle(sort: true).to_i}
      .sum
  end

end

puzzel = Day05.new(input.dup)

printf("%s: Day 05, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 05, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)
