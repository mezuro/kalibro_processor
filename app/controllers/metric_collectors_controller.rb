require 'metric_collector'

class MetricCollectorsController < ApplicationController
  def all_names
    names = { metric_collector_names: MetricCollector::KolektiAdapter.available.map(&:name) }

    respond_to do |format|
      format.json { render json: names }
    end
  end

  def index
    respond_to do |format|
      format.json { render json: MetricCollector::KolektiAdapter.details }
    end
  end

  def find
    details = MetricCollector::KolektiAdapter.details.find { |d| d.name == params[:name] }

    respond_to do |format|
      if details.nil?
        error = Errors::NotFoundError.new("Metric Collector #{params[:name]} not found.")
        format.json { render status: :not_found, json: { error: error } }
      else
        format.json { render json: { metric_collector_details: details } }
      end
    end
  end
end
