class MetricResultsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, Likeno::Errors::RecordNotFound, with: :not_found
  before_action :set_metric_result

  def repository_id
    format_response({ repository_id: @metric_result.processing.repository.id })
  end

  def metric_configuration
    format_response({ metric_configuration: @metric_result.metric_configuration })
  end

  def module_result
    format_response({module_result: @metric_result.module_result})
  end

  protected

  def set_metric_result
    begin
      @metric_result = MetricResult.find(params[:id].to_i)
      true
    rescue ActiveRecord::RecordNotFound => exception
      respond_to do |format|
        format.json { render json: {errors: [exception.message]}, status: :not_found }
      end
      false
    end
  end
end
