class RepositoriesController < ApplicationController
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
    set_repository

    respond_to do |format|
      if @repository.update(repository_params)
        format.json { render json: {repository: @repository} , status: :created }
      else
        format.json { render json: {repository: @repository} , status: :unprocessable_entity }
      end
    end
  end

  def destroy
    set_repository

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
      set_repository
      @repository.process
      status = :ok
    rescue Errors::ProcessingError
      status = :internal_server_error
    end
    respond_to do |format|
      format.json { render json: {}, status: status }
    end
  end

  def has_processing
    set_repository
    respond_to do |format|
      format.json { render json: { has_processing: !@repository.processings.empty? } }
    end
  end

  def has_ready_processing
    set_repository

    ready_processings = Processing.where(repository: @repository, state: "READY")

    respond_to do |format|
      format.json { render json: { has_ready_processing: !ready_processings.empty? } }
    end
  end

  def has_processing_in_time
    set_repository

    order = params[:after_or_before] == "after" ? ">=" : "<="

    processings = Processing.find_by_repository_and_date(@repository, params[:date], order)

    respond_to do |format|
      format.json { render json: { has_processing_in_time: !processings.empty? } }
    end
  end

  def last_ready_processing
    set_repository

    ready_processings = Processing.where(repository: @repository, state: "READY")

    respond_to do |format|
      format.json { render json: { last_ready_processing: ready_processings.last } }
    end
  end

  def first_processing_in_time
    set_repository

    if params[:date].nil?
      processings = Processing.where(repository: @repository)
    else
      order = params[:after_or_before] == "after" ? ">=" : "<="
      processings = Processing.find_by_repository_and_date(@repository, params[:date], order)
    end

    respond_to do |format|
      format.json { render json: { processing: processings.first } }
    end
  end

  private

  def set_repository
    @repository = Repository.find(params[:id].to_i)
  end

  def repository_params
    params.require(:repository).permit(:name, :address, :license, :scm_type, :description, :period, :configuration_id, :project_id)
  end
end
