class ModuleResultsController < ApplicationController
  def get
    module_result = ModuleResult.find(params[:id])

    respond_to do |format|
      if module_result.is_a?(ModuleResult)
        format.json { render json: {module_result: module_result} }
      else
        format.json { render json: module_result, status: :unprocessable_entity }
      end
    end
  end
end
