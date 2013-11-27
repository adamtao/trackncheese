class SongsController < ApplicationController
	before_filter :new_song, only: :create
	load_resource :project
	load_and_authorize_resource only: [:show, :new, :create, :destroy]

	def show
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
		params.require(:song).permit(:title)
	end

end
