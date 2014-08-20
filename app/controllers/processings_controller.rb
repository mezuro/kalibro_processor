class ProcessingsController < ApplicationController
  def process_times
    processing = Processing.find(params[:id].to_i)
    process_times = processing.process_times.map { |process_time| JSON.parse(process_time.to_json) }

    respond_to do |format|
      format.json { render json: {process_times: process_times} }
    end
  end

  def error_message
    error_message = Processing.find(params[:id].to_i).error_message

    respond_to do |format|
      format.json { render json: {error_message: error_message} }
    end
  end
end
