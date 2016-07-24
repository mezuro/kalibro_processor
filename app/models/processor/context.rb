require 'metric_collector'

module Processor
  class Context
    attr_accessor :repository, :native_metrics, :compound_metrics, :processing

    def initialize(params={})
      @repository = params[:repository]
      @processing = params[:processing]
      @native_metrics = Hash.new do |hash, key|
        hash[key] = []
      end
      @compound_metrics = []
    end

    def tree_native_metrics
      native_metrics.values.flat_map do |metrics|
        metrics.select { |mc| mc.metric.type == 'NativeMetricSnapshot' }
      end
    end

    def tree_metrics
      tree_native_metrics + compound_metrics
    end
  end
end
