class ProjectsController < ApplicationController
  def all
    projects = {projects: Project.all}

    respond_to do |format|
      format.json { render json: projects }
    end
  end

  def show
    if set_project
      respond_to do |format|
        format.json { render json: {project: @project}, status: :ok }
      end
    end
  end

  def create
    project = Project.new(project_params)

    respond_to do |format|
      if project.save
        format.json { render json: {project: project}, status: :created }
      else
        format.json { render json: {errors: project.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  def update
    if set_project
      respond_to do |format|
        if @project.update(project_params)
          format.json { render json: {project: @project}, status: :created }
        else
          format.json { render json: {errors: @project.errors.full_messages}, status: :unprocessable_entity }
        end
      end
    end
  end

  def exists
    respond_to do |format|
      format.json { render json: {exists: Project.exists?(params[:id].to_i)} }
    end
  end

  def repositories_of
    if set_project
      respond_to do |format|
        format.json { render json: {repositories: @project.repositories} }
      end
    end
  end

  def destroy
    if set_project
      @project.destroy
      respond_to do |format|
        format.json { render json: {}, status: :ok }
      end
    end
  end

  private

  def set_project
    begin
      @project = Project.find(params[:id].to_i)
      true
    rescue ActiveRecord::RecordNotFound => exception
      respond_to do |format|
        format.json { render json: {errors: [exception.message]}, status: :not_found }
      end
      false
    end
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
