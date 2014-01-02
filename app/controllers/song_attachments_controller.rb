class SongAttachmentsController < ApplicationController
	before_filter :new_song_attachment, only: :create
	load_resource :project
	load_resource :song
	load_resource

	def create
		@song_attachment.song = @song
		authorize! :create, @song_attachment
		if @song_attachment.save
			redirect_to redirect_path, notice: "Nice. Your attachment was added to the song."
		else
			redirect_to redirect_path, alert: "Hrmmm. Something went wrong. Try again?"
		end
	end

	def destroy
		if @song_attachment.destroy
			redirect_to redirect_path, notice: "The file was deleted."
		else
			redirect_to redirect_path, alert: "There was a problem deleting the file."
		end
	end

private

	def redirect_path
		project_song_path(@project, @song, active_tab: 'attachments')
	end

	# Do this before cancan's methods so the strong parameters are in place.
	#
	def new_song_attachment
	  @song_attachment = SongAttachment.new(safe_params)
	end

	# Setup which params can be passed in via web forms
	#
	def safe_params
		params.require(:song_attachment).permit(:attachment)
	end

end