#! /usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction     => false
}

require 'pp'
require 'set'
require 'thread/pool'

input = File.read("../#{ARGV[0]}").split(/\n/)

class Trails

  def initialize(map)
    @map = map.map {|r| r.chars.map(&:to_i)}
    @xob = @map.first.size
    @yob = @map.size
  end

  def scores(distinct: false)
    trail_heads.map {|x, y| score(x, y, distinct)}
  end

  private

  def trail_heads()
    ypos, xpos, heads = 0, 0, []

    while ypos < @yob do
      heads << [xpos, ypos] if @map[ypos][xpos] == 0
      if xpos == @xob - 1
        xpos = 0; ypos += 1
      else
        xpos += 1
      end
    end

    return heads
  end

  def score(x, y, distinct = false, nines = Set.new)
    if @map[y][x] == 9
      if nines.include?([x,y])
        return 0
      else
        nines << [x, y] unless distinct
        return 1
      end
    end

    return [[ 1, 0], [ 0, 1], [-1, 0], [ 0, -1]]
      .map    {|dx, dy| [x + dx, y + dy]}
      .reject {|fx, fy| 0 > fx || fx >= @xob || 0 > fy || fy >= @yob }
      .select {|fx, fy| @map[fy][fx] == @map[y][x] + 1 }
      .map    {|fx, fy| score(fx, fy, distinct, nines) }
      .compact
      .sum
  end

end

class Day10

  def initialize(input)
    @input = input.map(&:chomp)
  end

  def part_1()
    Trails.new(@input).scores.sum
  end

  def part_2()
    Trails.new(@input).scores(distinct: true).sum
  end

end

puzzel = Day10.new(input.dup)

printf("%s: Day 10, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 10, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)
