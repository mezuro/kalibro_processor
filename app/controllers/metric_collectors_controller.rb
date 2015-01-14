require 'metric_collector'

class MetricCollectorsController < ApplicationController
  def all_names
    names = {metric_collector_names: MetricCollector::Native.available.keys }

    respond_to do |format|
      format.json { render json: names }
    end
  end

  def index
    respond_to do |format|
      format.json { render json: MetricCollector::Native.details}
    end
  end

  def find
    details = MetricCollector::Native.details.bsearch{|d| d.name == params[:name]}
    if details.nil?
      return_value = {error: Errors::NotFoundError.new("Metric Collector #{params[:name]} not found.")}
    else
      return_value = {metric_collector_details: details}
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
