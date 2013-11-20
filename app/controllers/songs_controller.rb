class SongsController < ApplicationController
	load_and_authorize_resource only: [:show, :create]

	def show
	end

end
