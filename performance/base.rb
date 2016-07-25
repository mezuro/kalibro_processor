require 'fileutils'
require 'database_cleaner'
require 'kalibro_client/kalibro_cucumber_helpers'

module Performance
  class Base
    def initialize(num_runs: nil, measure_mode: nil, save_reports: true, rand_seed: nil)
      if num_runs.nil?
        num_runs = ENV.key?('PROFILE_NUM_RUNS') ? ENV['PROFILE_NUM_RUNS'].to_i : 1
      end

      if rand_seed.nil? && ENV.key?('PROFILE_RAND_SEED')
        rand_seed = ENV['PROFILE_RAND_SEED'].to_i
      end

      @num_runs = num_runs
      @measure_mode = measure_mode
      @save_reports = save_reports
      @rand_seed = rand_seed
      @results = []
    end

    def setup
      Random.srand(@rand_seed) if @rand_seed
      STDERR.puts "Using random seed #{Random::DEFAULT.seed}"

      DatabaseCleaner.strategy = :truncation
      KalibroClient::KalibroCucumberHelpers.clean_configurations
      DatabaseCleaner.clean
    end

    def teardown
      KalibroClient::KalibroCucumberHelpers.clean_configurations
      DatabaseCleaner.clean
    end

    def subject; raise NotImplementedError; end

    def run
      STDERR.puts "Profiling #{self.class.name}"

      if @measure_mode
        RubyProf.measure_mode = RubyProf.const_get(@measure_mode)
      end

      @results = (1..@num_runs).map do |i|
        STDERR.puts "Setup: start"
        self.setup
        STDERR.puts "Setup: finish"

        STDERR.puts "Run #{i}: start"
        prof = RubyProf.profile do
          self.subject
        end
        STDERR.puts "Run #{i}: finish"

        STDERR.puts "Teardown: start"
        self.teardown
        STDERR.puts "Teardown: finish"

        prof
      end

      self.save_reports if @save_reports
      self.print
    end

    protected

    def print
      puts "#{@measure_mode.to_s}:"

      if RubyProf.measure_mode == RubyProf::WALL_TIME
        totals = @results.map { |r| r.threads.map(&:total_time).max }
      else
        totals = @results.map { |r| r.threads.map(&:total_time).reduce(:+) }
      end

      totals.each do |time|
        puts "  #{time}"
      end

      puts "  Average: #{totals.reduce(:+) / @results.count}"
      puts
    end

    def save_reports
      path = "prof/#{self.class.name}"
      FileUtils.mkdir_p(path)
      base_prof = Time.now.strftime('%Y-%m-%d_%H-%M-%S')

      @results.each_with_index do |result, i|
        printer = RubyProf::MultiPrinter.new(result)
        printer.print(path: path, profile: "#{base_prof}_#{i}")
      end
    end
  end
end
