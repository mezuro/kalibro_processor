class ProcessingsController < ApplicationController
  def process_times
    processing = Processing.find(params[:id].to_i)
    process_times = processing.process_times.map { |process_time| JSON.parse(process_time.to_json) }

    respond_to do |format|
      format.json { render json: {process_times: process_times}, status: status }
    end
  end
end