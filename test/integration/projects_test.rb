require 'test_helper'

# Testing what you can do with projects

class ProjectsIntegrationTest < ActionDispatch::IntegrationTest

	describe "Access" do 

		it "should not access projects I dont own" do 
			not_my_project = FactoryGirl.create(:single_project)
			visit project_path(not_my_project)
			current_path.must_equal root_path
		end

		it "should access projects in my cookies" do 
			my_cookie_project
			project = Project.last
			visit project_path(project)
			current_path.must_equal project_path(project)
		end

	end

	describe "Project page" do 

		before do
			@project = my_cookie_project
		end

		it "should have project-level tasks"

		it "should list songs" do 
			song = @project.songs.first
			must_have_link song.title, href: project_song_path(@project, song)
		end
		
		it "should quick-edit song names"
		it "should have a link to add a new song"
	end

end