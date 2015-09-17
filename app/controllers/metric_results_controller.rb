class MetricResultsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, KalibroClient::Errors::RecordNotFound, with: :not_found
  before_action :set_metric_result

  def repository_id
    format_response({ repository_id: @metric_result.processing.repository.id })
  end

  def metric_configuration
    format_response({ metric_configuration: @metric_result.metric_configuration })
  end

  protected

  def set_metric_result
    raise NotImplementedError
  end
end
