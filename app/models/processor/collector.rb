module Processor
  class Collector
    def self.collect(runner)
      runner.native_metrics.each do |base_tool_name, wanted_metrics|
        unless wanted_metrics.empty?
          Runner::BASE_TOOLS[base_tool_name].new.
            collect_metrics(runner.repository.code_directory,
                            wanted_metrics,
                            runner.processing)
        end
      end
    end
  end
end

