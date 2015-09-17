class HotspotMetricResultsController < MetricResultsController
  def related_results
    format_response({ hotspot_metric_results: @metric_result.related_results })
  end

  protected

  def set_metric_result
    @metric_result = HotspotMetricResult.find(params[:id].to_i)
  end
end
