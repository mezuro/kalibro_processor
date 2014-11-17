class KalibroModulesController < ApplicationController
  before_action :set_kalibro_module, only: [:module_results, :update, :destroy]

  def index
    respond_to do |format|
      format.json {render json: {kalibro_module: KalibroModule.all}}
    end
  end

  def show
    begin
      set_kalibro_module
      response = {kalibro_module: @kalibro_module}
      status = :ok
    rescue ActiveRecord::RecordNotFound
      response = {error: 'RecordNotFound'}
      status = :unprocessable_entity
    end

    respond_to do |format|
      format.json {render json: response, status: status}
    end
  end

  def create
    @kalibro_module = KalibroModule.new(kalibro_module_params)

    respond_to do |format|
      if @kalibro_module.save
        format.json { render json: {kalibro_module: @kalibro_module}, status: :created }
      else
        format.json { render json: {kalibro_module: @kalibro_module}, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @kalibro_module.update(kalibro_module_params)
        format.json { render json: {kalibro_module: @kalibro_module}, status: :ok }
      else
        format.json { render json: {kalibro_module: @kalibro_module}, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @kalibro_module.destroy
    respond_to do |format|
      format.json { head :no_content }
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

    def kalibro_module_params
      #params["kalibro_module"]["name"] = JSON.parse(params["kalibro_module"]["name"]) if params["kalibro_module"]["name"].starts_with?("[") and params["kalibro_module"]["name"].ends_with?("]")
      params.require(:kalibro_module).permit(:granularity, :name)
    end
end

