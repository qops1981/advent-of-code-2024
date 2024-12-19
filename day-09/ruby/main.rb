#! /usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction     => false
}

require 'pp'
require 'set'
require 'thread/pool'

input = File.read("../#{ARGV[0]}")

class Disk

  class ContigiousSegments

    attr_accessor :files, :fid, :pos, :spaces

    def initialize(files: Hash.new {|h, k| h[k] = []}, fid: 0, pos: 0, spaces: [])
      @files = files
      @fid = fid
      @pos = pos
      @spaces = spaces
    end

    def file()
      @files[@fid]
    end

    def file=(v)
      @files[@fid] = v.is_a?(Array) ? v : [@pos, v]
    end

    def space=(v)
      @spaces << [@pos, v]
    end

  end

  def initialize(compressed)
    @compressed = compressed.chars.map(&:to_i)
  end

  def decompressed()
    @decompressed ||= @compressed.flat_map.with_index {|c, i| Array.new(c, i.even? ? i / 2 : nil)}
  end

  def segments()
    @segments ||= @compressed
      .each_with_index
      .inject(ContigiousSegments.new()) do |css, (dig, idx)|
        if idx % 2 == 0
          css.file = dig; css.fid += 1
        else
          css.space = dig unless dig == 0
        end

        css.pos += dig; css
      end
  end

  def segment_defrag()
    while segments.fid > 0 do
      segments.fid -= 1
      pos, siz = segments.file

      segments.spaces.each_with_index do |(str, len), idx|
        case
        when str >= pos
          segments.spaces = segments.spaces[..idx]
          break
        when siz <= len
          segments.file = [str, siz]
          siz == len ? segments.spaces.delete_at(idx) : segments.spaces[idx] = [str + siz, len - siz]
          break
        end
      end
    end
    segments
  end

  def defrag()
    blanks = decompressed.each_index.select {|i| decompressed[i].nil?}
    blocks = ((0..decompressed.size - 1).to_a - blanks).reverse

    blanks.each_index do |i|
      break if blanks[i] > blocks.size - 1

      blank, block = blanks[i], blocks[i]

      decompressed[blank] = decompressed[block]
      decompressed[block] = nil
    end

    decompressed
  end

end

class Day09

  def initialize(input)
    @input = input.chomp
  end

  def part_1()
    Disk.new(@input).defrag
      .compact
      .map.with_index {|b, i| i * b }
      .sum
  end

  def part_2()
    Disk.new(@input).segment_defrag
      .files.inject(0) do |sum, (fid, (str, siz))|
        (str...str + siz).each {|pos| sum += fid * pos}; sum
      end
  end

end

puzzel = Day09.new(input.dup)

printf("%s: Day 09, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 09, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)
