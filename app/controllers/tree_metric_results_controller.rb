class TreeMetricResultsController < MetricResultsController
  def descendant_values
    format_response({ descendant_values: @metric_result.descendant_values })
  end

  protected

  def set_metric_result
    @metric_result = TreeMetricResult.find(params[:id].to_i)
  end
end
