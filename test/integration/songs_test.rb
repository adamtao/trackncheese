require 'test_helper'

# Testing what you can do with songs

class SongsIntegrationTest < ActionDispatch::IntegrationTest

	describe "Single song project" do 

		it "should look different than songs from a multi-song project"
		it "should have the ability to add songs to the parent project--changing it into a multisong project"

	end

	describe "Access" do 

		it "should not access songs I dont own" do 
			not_my_project = FactoryGirl.create(:single_project)
			visit project_song_path(not_my_project, not_my_project.songs.first)
			current_path.must_equal root_path
		end

		it "should access songs from projects in my cookies" do 
			project = my_cookie_project
			song = project.songs.first
			visit project_song_path(project, song)
			current_path.must_equal project_song_path(project, song)
		end

	end

	describe "Song page" do 
		it "should have tasks"
		it "should have the arranger"
		it "should show a progress indicator"
	end

end