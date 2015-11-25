class ProcessTimesController < ApplicationController
  before_action :set_process_time, only: [:processing]

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
      status = :not_found
    end

    respond_to do |format|
      format.json {render json: response, status: status}
    end
  end

  def processing
    respond_to do |format|
      format.json {render json: {processing: @process_time.processing}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_time
      @process_time = ProcessTime.find(params[:id].to_i)
    end
end
