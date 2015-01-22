class ModuleResultsController < ApplicationController
  def get
    record = find_module_result
    format_response(record, { module_result: record })
  end

  def exists
    respond_to do |format|
      format.json { render json: {exists: ModuleResult.exists?(params[:id].to_i)} }
    end
  end

  def metric_results
    record = find_module_result
    return_value = record.is_a?(ModuleResult) ? { metric_results: record.metric_results } : record
    format_response(record, return_value)
  end

  def children
    record = find_module_result
    if record.is_a?(ModuleResult)
      return_value = { module_results: record.children }
    else
      return_value = record
    end

    format_response(record, return_value)
  end

  def repository_id
    record = find_module_result

    respond_to do |format|
      if record.is_a?(ModuleResult)
        format.json { render json: {repository_id: record.processing.repository.id} }
      else
        format.json { render json: record, status: :unprocessable_entity }
      end
    end
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
