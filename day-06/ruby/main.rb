#! /usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction     => false
}

require 'pp'
require 'set'
require 'thread/pool'

input = File.read("../#{ARGV[0]}").split("\n")

class Guard

  Path = Struct.new(:walked)
  Loop = Struct.new(:walked)

  def initialize(map)
    @map = map
    @sty = @map.index {|r| r.include?("^")}
    @stx = @map[@sty].chars.index("^")
    @xob = @map[0].size
    @yob = @map.size
  end

  def path(x = @stx, y = @sty, dx = 0, dy = -1, h1 = Set.new, h2 = Set.new)
    loop do
      h1 << [ x, y ]
      h2 << [ x, y, dx, dy ]

      return Path.new(h1) if oob?(x + dx, y + dy)

      if @map[y + dy][x + dx] == '#'
        dx, dy = -dy, dx
      else
        x += dx
        y += dy
      end

      return Loop.new(h2) if h2.include?([ x, y, dx, dy ])
    end
  end

  private

  def oob?(x,y)
    x < 0 || x >= @xob || y < 0 || y >= @yob
  end
end

class Day06

  def initialize(input)
    @map = input.map(&:chomp)
  end

  def part_1()
    Guard.new(@map).path.walked.size
  end

  def part_2(count = 0, pool = Thread.pool(32), iters = 0)
    (0..@map.size - 1).flat_map {|y| (0..@map[0].size - 1).map {|x| [x, y] } }
      .select {|x, y| @map[y][x] == '.' }
      .each do |x, y|
        ot = Marshal.load(Marshal.dump(@map))
        ot[y][x] = '#'

        pool.process do
          count +=1 if Guard.new(ot).path.instance_of?(Guard::Loop)
        end

        printf("\rIters: %d", iters += 1)
      end
      puts
      count
  end

end

puzzel = Day06.new(input.dup)

printf("%s: Day 06, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 06, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)
