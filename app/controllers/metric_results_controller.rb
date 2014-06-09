class MetricResultsController < ApplicationController
  def descendant_values
    metric_result = MetricResult.find(params[:id])
    descendant_values = {descendant_values: metric_result.descendant_values}

    respond_to do |format|
      format.json { render json: descendant_values }
    end
  end
end
