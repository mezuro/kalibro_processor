module Performance
  class Base
    def initialize
      @results = {}
    end

    def setup; end
    def teardown; end

    def subject; raise NotImplementedError; end

    def run
      self.run_process_time
      self.run_wall_time

      self.print
    end

    protected

    def run_wall_time
      self.setup

      RubyProf.measure_mode = RubyProf::WALL_TIME

      @results['Wall Time'] = []
      (1..5).each do |it|
        @results['Wall Time'] << RubyProf.profile do
          self.subject
        end
      end

      self.teardown
    end

    def run_process_time
      self.setup

      RubyProf.measure_mode = RubyProf::PROCESS_TIME

      @results['Process Time'] = []
      (1..5).each do |it|
        @results['Process Time'] << RubyProf.profile do
          self.subject
        end
      end

      self.teardown
    end

    def print
      puts "\n"
      puts "#{self.class.name}\n----------"

      @results.each do |title, result|
        total = 0.0

        result.each { |r| r.threads.each { |thread| total += thread.total_time} }

        puts "* #{title}: #{total/result.count}"
      end
      puts "\n"
    end
  end
end
