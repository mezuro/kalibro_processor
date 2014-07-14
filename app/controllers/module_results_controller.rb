class ModuleResultsController < ApplicationController
  def get
    record = find_module_result
    format_response(record, record)
  end

  def metric_results
    record = find_module_result
    return_value = record.is_a?(ModuleResult) ? record.metric_results : record
    format_response(record, return_value)
  end

  def children
    record = find_module_result
    return_value = record.is_a?(ModuleResult) ? record.children : record
    format_response(record, return_value)
  end

  private

  def find_module_result
    begin
      ModuleResult.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      {error: 'RecordNotFound'}
    end
  end

  def format_response(record, return_value)
    respond_to do |format|
      if record.is_a?(ModuleResult)
        format.json { render json: return_value }
      else
        format.json { render json: return_value, status: :unprocessable_entity }
      end
    end
  end
end