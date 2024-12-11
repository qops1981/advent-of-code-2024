#! /usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}

input = File.read("../#{ARGV[0]}").split("\n")

class WordSearch

  def initialize(wordsearch)
    @wordsearch = wordsearch
    @last_x_pos = @wordsearch.first.size - 1
    @last_y_pos = @wordsearch.size - 1
  end

  def xmas(count = 0)
    (0..@last_y_pos).each do |y|
      (0..@last_x_pos).each do |x|
        next unless @wordsearch[y][x] == "X"
        [[ 1, 0], [ 1, 1], [ 0, 1], [-1, 1], [-1, 0], [-1,-1], [ 0,-1], [ 1,-1]].each do |dx, dy|
          x1, y1 = [x +       dx  , y +       dy  ]
          x2, y2 = [x + ( 2 * dx ), y + ( 2 * dy )]
          x3, y3 = [x + ( 3 * dx ), y + ( 3 * dy )]

          next if x3 < 0 || y3 < 0 || x3 > @last_x_pos || y3 > @last_y_pos

          seek = [@wordsearch[y1][x1], @wordsearch[y2][x2], @wordsearch[y3][x3]].join

          count +=1 if seek == "MAS"
        end
      end
    end

    count
  end

  def x_mas(count = 0)
    (1..@last_y_pos - 1).each do |y|
      (1..@last_x_pos - 1).each do |x|
        next unless @wordsearch[y][x] == "A"

        corners = [[-1,-1], [1, -1], [1,1], [-1, 1]].map {|dx, dy| @wordsearch[y + dy][x + dx]}.join
        count +=1 if ["MMSS", "MSSM", "SSMM", "SMMS"].include?(corners)
      end
    end

    count
  end
end

class Day04

  def initialize(input)
    @input = input.map(&:chomp)
  end

  def part_1()
    WordSearch.new(@input).xmas
  end

  def part_2()
    WordSearch.new(@input).x_mas
  end

end

puzzel = Day04.new(input.dup)

printf("%s: Day 04, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 04, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)