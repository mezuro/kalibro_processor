class MetricResultsController < ApplicationController
  def descendant_values
    metric_result = TreeMetricResult.find(params[:id])
    descendant_values = { descendant_values: metric_result.descendant_values }

    respond_to do |format|
      format.json { render json: descendant_values }
    end
  end

  def repository_id
    record = find_metric_result

    respond_to do |format|
      if record.is_a?(TreeMetricResult)
        format.json { render json: { repository_id: record.processing.repository.id } }
      else
        format.json { render json: record, status: :unprocessable_entity }
      end
    end
  end

  def metric_configuration
    metric_result = find_metric_result

    respond_to do |format|
      if metric_result.is_a?(TreeMetricResult)
        format.json { render json: { metric_configuration: metric_result.metric_configuration } }
      else
        format.json { render json: metric_result, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_metric_result
    begin
      TreeMetricResult.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      { error: 'RecordNotFound' }
    end
  end
end
