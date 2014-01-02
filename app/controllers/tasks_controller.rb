class TasksController < ApplicationController
	before_filter :new_task, only: :create
	load_resource :project
	before_filter :load_song_if_present
	load_and_authorize_resource only: [:show, :edit, :update, :destroy, :toggle]
	load_resource only: [:new, :create]

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
		if params[:song_id]
			@task.song = @song
			@element = [@project, @song, @task]
		else
			@task.project = @project
			@element = [@project, @task]
		end
		authorize! :create, @task
	end

	def create	
		if params[:song_id]	
			@task.song_id = @song.id 
			@element = [@project, @song, @task]
		else
			@task.project_id = @project.id
			@element = [@project, @task]
		end
		authorize! :create, @task
		if @task.save
			redirect_to redirect_path, notice: "Groovy. Your new task was added."
		else
			render action: 'new'
		end
	end

	def edit
		@element = (params[:song_id]) ? [@project, @song, @task] : [@project, @task]
	end

	def update
		if @task.update_attributes(safe_params)
			redirect_to redirect_path, notice: "All set. Your task was updated."
		else
			render action: 'edit'
		end		
	end

	def destroy
		@task.destroy
		redirect_to redirect_path
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

	# Build the redirect URL
	def redirect_path
		r = [@project]
		if params[:song_id]	
			r << @song
		end
		r
	end

end
