#! /usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction     => false
}

require 'pp'
require 'set'
require 'thread/pool'

input = File.read("../#{ARGV[0]}").split("\n")

class Map

  def initialize(map)
    @xob = map.first.size - 1
    @yob = map.size       - 1

    @frequencies = Hash.new {|h, k| h[k] = []}

    map.each_with_index do |row, y|
      row.chars.each_with_index do |char, x|
        @frequencies[char] << [x,y] unless ['#', '.'].include?(char)
      end
    end
  end

  def antinodes(all: false, nodes: Set.new)
    inner = @frequencies
      .values
      .flat_map {|v| v.permutation(2).to_a}

    inner.each do |a1, a2|
      dx = a2[0] - a1[0]
      dy = a2[1] - a1[1]
      x, y = a2

      nodes << [x, y] if all
      loop do
        x += dx
        y += dy

        x >= 0 && x <= @xob && y >= 0 && y <= @yob ? nodes << [x,y] : break
        break unless all
      end
    end

    nodes.size
  end

end

class Day08

  def initialize(input)
    @input = input.map(&:chomp)
  end

  def part_1()
    Map.new(@input).antinodes
  end

  def part_2()
    Map.new(@input).antinodes(all: true)
  end

end

puzzel = Day08.new(input.dup)

printf("%s: Day 08, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 08, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)
