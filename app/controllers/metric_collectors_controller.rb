require 'metric_collector'

class MetricCollectorsController < ApplicationController
  def all_names
    names = {metric_collector_names: MetricCollector::Native.available.keys }

    respond_to do |format|
      format.json { render json: names }
    end
  end

  def find
    metric_collector = MetricCollector::Native.available.values_at(params[:name]).first
    if metric_collector.nil?
      return_value = {error: Errors::NotFoundError.new("Metric Collector #{params[:name]} not found.")}
    else
      return_value = {metric_collector: metric_collector.new}
    end

    respond_to do |format|
      if return_value[:error].nil?
        format.json { render json: return_value}
      else
        format.json { render json: return_value, status: :unprocessable_entity }
      end
    end
  end
end