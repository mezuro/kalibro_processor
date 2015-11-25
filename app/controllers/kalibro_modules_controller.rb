class KalibroModulesController < ApplicationController
  before_action :set_kalibro_module, only: [:module_results]

  def index
    respond_to do |format|
      format.json {render json: {kalibro_module: KalibroModule.all}}
    end
  end

  def exists
    respond_to do |format|
      format.json {render json: {exists: KalibroModule.exists?(params[:id].to_i)}}
    end
  end

  def show
    begin
      set_kalibro_module
      response = {kalibro_module: @kalibro_module}
      status = :ok
    rescue ActiveRecord::RecordNotFound
      response = {error: 'RecordNotFound'}
      status = :not_found
    end

    respond_to do |format|
      format.json {render json: response, status: status}
    end
  end

  def module_results
    respond_to do |format|
      format.json {render json: {module_results: @kalibro_module.module_results}}
    end
  end

  private
    def set_kalibro_module
      @kalibro_module = KalibroModule.find(params[:id].to_i)
    end
end
