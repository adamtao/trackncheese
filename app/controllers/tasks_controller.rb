class TasksController < ApplicationController
	before_filter :new_task, only: :create
	load_resource :project
	before_filter :load_song_if_present
	load_and_authorize_resource only: [:show, :new, :create, :edit, :update, :destroy, :toggle]

	def toggle
    @task.completed_at = @task.completed_at.blank? ? Time.now : nil
    @task.save
    respond_to do |format|
      format.html { 
      	redirect_to (@task.song.present?) ? [@project, @song] : @project
      }
      format.js { render nothing: true }
    end
	end

	def new
		@element = (params[:song_id]) ? [@project, @song, @task] : [@project, @task]
	end

	def create	
		redirect = [@project]
		if params[:song_id]	
			@task.song_id = @song.id 
			redirect << @song
		else
			@task.project_id = @project.id
		end
		if @task.save
			redirect_to redirect, notice: "Groovy. Your new task was added."
		else
			render action: 'new'
		end
	end

	def edit
		@element = (params[:song_id]) ? [@project, @song, @task] : [@project, @task]
	end

	def update
		redirect = [@project]
		if params[:song_id]	
			redirect << @song
		end
		if @task.update_attributes(safe_params)
			redirect_to redirect, notice: "All set. Your task was updated."
		else
			render action: 'edit'
		end		
	end

private

	# Do this before cancan's methods so the strong parameters are in place.
	#
	def new_task
	  @task = Task.new(safe_params)
	end

	# Setup which params can be passed in via web forms
	#
	def safe_params
		params.require(:task).permit(:name, :due_on)
	end

	# Load the @song if params[:song_id] is given
	#
	def load_song_if_present
		if params[:song_id]
			@song = Song.find params[:song_id]
		end
	end

end
