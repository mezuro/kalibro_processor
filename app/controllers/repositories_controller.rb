class RepositoriesController < ApplicationController

  def branches
    scm_type = params[:scm_type]
    begin
      downloader = Downloaders::ALL[scm_type]
      if downloader
        respond_with_json({branches: downloader.branches(params[:url])})
      else
        respond_with_json({errors: ["#{scm_type}: Unknown SCM type"]}, :not_found)
      end
    rescue Git::GitExecuteError
      respond_with_json({errors: ["#{scm_type}ExecuteError: Invalid url"]}, :unprocessable_entity)
    rescue NotImplementedError
      respond_with_json({errors: ["#{scm_type}: Branch listing is not supported for this SCM type"]}, :unprocessable_entity)
    end
  end

  def index
    respond_with_json({repositories: Repository.all})
  end

  def show
    if set_repository
      respond_with_json({repository: @repository})
    end
  end

  def create
    repository = Repository.new(repository_params)

    respond_to do |format|
      if repository.save
        format.json { render json: {repository: repository}, status: :created }
      else
        format.json { render json: {errors: repository.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  def update
    if set_repository
      respond_to do |format|
        if @repository.update(repository_params)
          format.json { render json: {repository: @repository}, status: :created }
        else
          format.json { render json: {errors: @repository.errors.full_messages}, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    if set_repository
      @repository.destroy
      respond_with_json({})
    end
  end

  def exists
    respond_with_json({exists: Repository.exists?(params[:id].to_i)})
  end

  def types
    respond_with_json({types: Repository.supported_types})
  end

  def process_repository
    if set_repository
      begin
        @repository.process(Processing.create(repository: @repository, state: "PREPARING"))
        status = :ok
        response = {}
      rescue Errors::ProcessingError => exception
        status = :internal_server_error
        response = {errors: [exception.message]}
      end
      respond_with_json(response, status)
    end
  end

  def has_processing
    respond_with_json({ has_processing: !@repository.processings.empty? }) if set_repository
  end

  def has_ready_processing
    respond_with_json({ has_ready_processing: !@repository.find_ready_processing.empty? }) if set_repository
  end

  def has_processing_in_time
    if set_repository
      order = params[:after_or_before] == "after" ? ">=" : "<="
      processings = @repository.find_processing_by_date(params[:date], order)

      respond_with_json({ has_processing_in_time: !processings.empty? })
    end
  end

  def last_ready_processing
    respond_with_json({ last_ready_processing: @repository.find_ready_processing.last }) if set_repository
  end

  def first_processing_in_time
    respond_with_json({ processing: processings_in_time.first }) if set_repository
  end

  def last_processing_in_time
    respond_with_json({ processing: processings_in_time.last }) if set_repository
  end

  def last_processing_state
    respond_with_json({ processing_state: @repository.processings.last.state }) if set_repository
  end

  def module_result_history_of
    if set_repository && set_kalibro_module_name
      history = @repository.module_result_history_of(@kalibro_module_name)

      respond_with_json({module_result_history_of: history})
    end
  end

  def metric_result_history_of
    if set_repository && set_kalibro_module_name
      history = @repository.metric_result_history_of(@kalibro_module_name, params[:metric_name])

      respond_with_json({metric_result_history_of: history})
    end
  end

  def cancel_process
    if set_repository
      processing = @repository.processings.last
      processing.update(state: "CANCELED") unless processing.nil? || processing.state == "READY"

      respond_with_json({})
    end
  end

  private

  def set_repository
    begin
      @repository = Repository.find(params[:id].to_i)
      true
    rescue ActiveRecord::RecordNotFound => exception
      respond_with_json({errors: [exception.message]}, :not_found)
      false
    end
  end

  def set_kalibro_module_name
    begin
      @kalibro_module_name = KalibroModule.find(params[:kalibro_module_id].to_i).long_name
      true
    rescue ActiveRecord::RecordNotFound => exception
      respond_with_json({errors: [exception.message]}, :not_found)
      false
    end
  end

  def repository_params
    params.require(:repository).permit(:name, :address, :branch, :license, :scm_type, :description, :period, :kalibro_configuration_id, :project_id)
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

  def respond_with_json(json, status=:ok)
    respond_to do |format|
      format.json { render json: json, status: status }
    end
  end
end
