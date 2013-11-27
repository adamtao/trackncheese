class TasksController < ApplicationController
	before_filter :new_task, only: :create
	load_resource :project
	before_filter :load_song_if_present
	load_and_authorize_resource only: [:show, :new, :create, :destroy, :toggle]

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
