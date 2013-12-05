class ProjectsController < ApplicationController
	before_filter :new_project, only: :create
	load_and_authorize_resource only: [:show, :create, :edit, :update, :destroy]

	# List all projects for current_user
	#
	def index	
	end

	# Show a Project.
	#
	def show
		redirect_to [@project, @project.songs.first] if @project.single?
	end

	# Form for a new Project
	#
	def new
		@project ||= Project.new_album(0)
	end

	# Starts a new single song project with one month to
	# complete.
	#
	def single
		@project = Project.new_single
		render action: :new
	end

	# Starts a new album project. Default initiates 12 songs
	# and 12 months to complete.
	#
	def album
		@project = Project.new_album(12) 
		render action: :new
	end

	# Save the new project. Store the id in a cookie in case this user
	# doesn't have an account.
	#
	def create
		if user_signed_in?
			@project.user_id = current_user.id
		end
		if @project.save
			store_project_in_cookie(@project)
			redirect_to @project
		else
			render action: :new 
		end
	end

	# Load a project for editing
	#
	def edit
	end

	# Update (save changes) to a given project
	#
	def update
		if @project.update_attributes(safe_params)
			redirect_to @project
		else
			render action: "edit"
		end
	end

	def destroy
		if @project.destroy
			remove_project_from_cookie(@project)
			redirect_to projects_path
		else
			redirect_to @project, alert: "There was a problem deleting the project"
		end
	end

private

	# Do this before cancan's methods so the strong parameters are in place.
	#
	def new_project
	  @project = Project.new(safe_params)
	end

	# Setup which params can be passed in via web forms
	#
	def safe_params
		params.require(:project).permit(:name, 
			:finish_on, 
			:preproduction, 
			:production, 
			:postproduction, 
			:pushiness, 
			:song_count,
			songs_attributes: [
				:title, :finish_on, :id, :_destroy
			]
		)
	end

	# Keep the project id in the cookie.
	#
	def store_project_in_cookie(project)
		cookies.permanent.signed[:my_projects] ||= []
		projects = [cookies.permanent.signed[:my_projects]]
		projects << project.id
		cookies.permanent.signed[:my_projects] = projects.flatten
	end

	# Remove the project from the cookie.
	#
	def remove_project_from_cookie(project)
		cookies.permanent.signed[:my_projects] ||= []
		pids = cookies.permanent.signed[:my_projects]
		pids.delete(project.id)
		cookies.permanent.signed[:my_projects] = pids
	end

end