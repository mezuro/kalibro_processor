class ModuleResultsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, Likeno::Errors::RecordNotFound, with: :not_found
  before_action :set_module_result, except: [:exists]

  def get
    format_response({ module_result: @module_result })
  end

  def kalibro_module
    format_response({ kalibro_module: @module_result.kalibro_module })
  end

  def exists
    format_response({ exists: ModuleResult.exists?(params[:id].to_i) })
  end

  def metric_results
    format_response({ tree_metric_results: @module_result.tree_metric_results })
  end

  def hotspot_metric_results
    format_response({ hotspot_metric_results: @module_result.descendant_hotspot_metric_results })
  end

  def descendant_hotspot_metric_results
    format_response({ hotspot_metric_results: @module_result.descendant_hotspot_metric_results })
  end

  def children
    format_response({ module_results: @module_result.children })
  end

  def repository_id
    format_response({ repository_id: @module_result.processing.repository.id })
  end

  private

  def set_module_result
    @module_result = ModuleResult.find(params[:id].to_i)
  end
end
