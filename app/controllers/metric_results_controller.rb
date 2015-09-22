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

  # This controller is never instantiated. Therefore this line won't be covered.
  # :nocov:
  def set_metric_results
    raise NotImplementedError
  end
  # :nocov:
end
