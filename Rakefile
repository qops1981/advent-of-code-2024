
require 'fileutils'
require 'http'
require 'json'
require 'uri'

class AdventOfCode

  module Api

    def call(*path, payload: nil)
      req = @request.dup

      req["json"] = payload unless payload.nil?

      url      = req.delete("endpoint").dup.push(__callee__.to_s, *path).join("/")
      response = HTTP.send(lower_class_name.to_sym, url, **req)

      raise response if response.status.to_i > 400

      response.body.to_s

    rescue => error
      puts error
    end

    def lower_class_name() self.class.name.split("::").last.downcase end

  end

  class HttpMethod

    include Api

    def initialize(request)
      @request = request
    end

  end

  # class Post < HttpMethod

  #   alias :queries       :call

  #   alias :query_results :call

  # end

  class Get < HttpMethod

    alias :input :call

  end

  def initialize(session:, year:, day:)
    @request = {
      "endpoint" => ["https://adventofcode.com", year, "day", day],
      "headers"  => {
      	"Cookie" 	 => "session=%s" % session,
      	"User-Agent" => "Ruby AOC Fetcher (github.com/qops1981/advent-of-code-%s)" % year
      }
    }
  end

  def post() Post.new(@request) end

  def get()  Get.new(@request)  end

end

raise("Error: No Session Key Found") unless ENV.key?('AOC_SESSION')

task :initialize, [:day] do |t, args|

	session = ENV['AOC_SESSION']
	year    = Dir.pwd.split("-").last

	puzzel_directory = "day-%02d" % args[:day]
	puzzel_input 	 = File.join(puzzel_directory, "input")
	
	aoc = AdventOfCode.new(session: session, year: year, day: args[:day])

	FileUtils.mkdir_p(puzzel_directory)

	File.write(puzzel_input, aoc.get.input)
end
