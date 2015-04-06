module MetricCollector
  module Native
    module MetricFu
      module Parser
        class Interface
          def parse(collected_metrics_hash); raise NotImplementedError; end
        end
      end
    end
  end
end