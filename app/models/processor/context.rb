require 'metric_collector'

module Processor
  class Context
    attr_accessor :repository, :native_metrics, :compound_metrics, :processing

    def initialize(params={})
      @repository = params[:repository]
      @processing = params[:processing]
      @native_metrics = {}
      MetricCollector::Native::ALL.each_key { |key| @native_metrics[key] = [] }
      @compound_metrics = []
    end
  end
end