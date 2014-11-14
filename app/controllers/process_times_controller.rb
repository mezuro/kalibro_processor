class ProcessTimesController < ApplicationController
  before_action :set_process_time, only: [:processing, :update, :destroy]

  def index
    respond_to do |format|
      format.json {render json: {process_time: ProcessTime.all}}
    end
  end

  def show
    begin
      set_process_time
      response = {process_time: @process_time}
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
    @process_time = ProcessTime.new(process_time_params)

    respond_to do |format|
      if @process_time.save
        format.json { render json: {process_time: @process_time}, status: :created }
      else
        format.json { render json: {process_time: @process_time}, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @process_time.update(process_time_params)
        format.json { render json: {process_time: @process_time}, status: :ok }
      else
        format.json { render json: {process_time: @process_time}, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @process_time.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def processing
    respond_to do |format|
      format.json {render json: {process_time: @process_time.processing}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_time
      @process_time = ProcessTime.find(params[:id].to_i)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def process_time_params
      params.require(:process_time).permit(:state, :created_at, :updated_at)
    end
end
