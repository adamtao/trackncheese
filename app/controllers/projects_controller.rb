class ProjectsController < ApplicationController

	def single
		@project = Project.new( name: "My Single" )
		@project.songs.build
		render action: :new
	end

	def album
		@project = Project.new( name: "My Album" )
		12.times { @project.songs.build }
		render action: :new
	end

	def new
	end

	def create
		# don't forget to store the project ids in the session
	end

end