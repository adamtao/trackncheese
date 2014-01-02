class SongsController < ApplicationController
	before_filter :new_song, only: :create
	load_resource :project
	load_and_authorize_resource only: [:show, :new, :create, :update, :destroy]

	def show
		@element = [@project, @song, Task.new(song: @song)] # element for the new task form
		@song_attachment = SongAttachment.new
		@active_tab = params[:active_tab] || 'tasks'
		respond_to do |format|
			format.html
			format.json 
		end
	end

	def new		
	end

	def create
		@song.project = @project
		if @song.save
			redirect_to @project, notice: "Cool. Your song was added to the project."
		else
			render action: 'new'
		end
	end

	def update
		@already_active = 0 # 1 = collapses all accordions in the rhymer
		url_options = {}
		if params[:active_tab]
			url_options[:active_tab] = params[:active_tab]
		end
		if @song.update_attributes(safe_params)
			respond_to do |format|
				format.html {	redirect_to project_song_path(@project, @song, url_options) }
				format.js
			end
		else
			respond_to do |format|
				format.html { render action: 'show' }
				format.js { render json: ["there was a problem"] }
			end
		end
	end

	def destroy
		if @song.destroy
			redirect_to @project
		else
			redirect_to [@project, @song], alert: "There was a problem deleting the song."
		end
	end

private

	# Do this before cancan's methods so the strong parameters are in place.
	#
	def new_song
	  @song = Song.new(safe_params)
	end

	# Setup which params can be passed in via web forms
	#
	def safe_params
		params.require(:song).permit(:title, :lyrics)
	end

end
