class RepositoriesController < ApplicationController
  before_action :set_repository, except: [:show, :create, :types]

  def show
    begin
      set_repository
      response = {repository: @repository}
      status = :ok
    rescue ActiveRecord::RecordNotFound
      response = {error: 'RecordNotFound'}
      status = :unprocessable_entity
    end

    respond_to do |format|
      format.json { render json: response, status: status }
    end
  end

  def create
    repository = Repository.new(repository_params)

    respond_to do |format|
      if repository.save
        format.json { render json: {repository: repository} , status: :created }
      else
        format.json { render json: {repository: repository} , status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @repository.update(repository_params)
        format.json { render json: {repository: @repository} , status: :created }
      else
        format.json { render json: {repository: @repository} , status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @repository.destroy
    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  def types
    supported_types = []
    supported_types = Repository.supported_types

    respond_to do |format|
      format.json { render json: {types: supported_types}, status: :ok }
    end
  end

  def process_repository #FIXME Naming this method process is causing conflicts. Fix them.
    begin
      @repository.process(Processing.create(repository: @repository, state: "PREPARING"))
      status = :ok
    rescue Errors::ProcessingError
      status = :internal_server_error
    end
    respond_to do |format|
      format.json { render json: {}, status: status }
    end
  end

  def has_processing
    respond_to do |format|
      format.json { render json: { has_processing: !@repository.processings.empty? } }
    end
  end

  def has_ready_processing
    ready_processings = @repository.find_ready_processing

    respond_to do |format|
      format.json { render json: { has_ready_processing: !ready_processings.empty? } }
    end
  end

  def has_processing_in_time
    order = params[:after_or_before] == "after" ? ">=" : "<="

    processings = @repository.find_processing_by_date(params[:date], order)

    respond_to do |format|
      format.json { render json: { has_processing_in_time: !processings.empty? } }
    end
  end

  def last_ready_processing
    ready_processings = @repository.find_ready_processing

    respond_to do |format|
      format.json { render json: { last_ready_processing: ready_processings.last } }
    end
  end

  def first_processing_in_time
    respond_to do |format|
      format.json { render json: { processing: processings_in_time.first } }
    end
  end

  def last_processing_in_time
    respond_to do |format|
      format.json { render json: { processing: processings_in_time.last } }
    end
  end

  def last_processing_state
    respond_to do |format|
      format.json { render json: { processing_state: @repository.processings.last.state } }
    end
  end

  def module_result_history_of
    module_name = KalibroModule.find(params[:module_id].to_i).long_name
    history = @repository.module_result_history_of(module_name)

    respond_to do |format|
      format.json { render json: {module_result_history_of: history} }
    end
  end

  def metric_result_history_of
    module_name = KalibroModule.find(params[:module_id].to_i).long_name
    history = @repository.metric_result_history_of(module_name, params[:metric_name])

    respond_to do |format|
      format.json { render json: {metric_result_history_of: history} }
    end
  end

  def cancel_process
    processing = @repository.processings.last
    processing.update(state: "CANCELED") unless processing.state == "READY"

    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  private

  def set_repository
    @repository = Repository.find(params[:id].to_i)
  end

  def repository_params
    params.require(:repository).permit(:name, :address, :license, :scm_type, :description, :period, :configuration_id, :project_id)
  end

  def processings_in_time
    if params[:date].nil?
      processings = @repository.processings
    else
      order = params[:after_or_before] == "after" ? ">=" : "<="
      processings = @repository.find_processing_by_date(params[:date], order)
    end

    processings
  end
end
