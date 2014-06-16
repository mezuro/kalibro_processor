class ModuleResultsController < ApplicationController
  def get
    begin
      module_result = ModuleResult.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      module_result = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if module_result.is_a?(ModuleResult)
        format.json { render json: module_result }
      else
        format.json { render json: module_result, status: :unprocessable_entity }
      end
    end
  end
end
