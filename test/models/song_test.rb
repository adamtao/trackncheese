require 'test_helper'

class SongTest < ActiveSupport::TestCase

	describe "Single song" do 

		before do 
			@project = FactoryGirl.create(:single_project)
			@song = @project.songs.first
		end

		it "#single? should be true" do 
			assert @song.single?
		end

		it "#finish_on should be the same as the project target date" do 
			assert @song.finish_on == @project.finish_on
		end

		it "should have the same days_to_complete as the project" do 
			assert @song.days_to_complete == @project.days_to_complete
		end

		it "should have the same start date as the project" do 
			assert @song.start_on == @project.start_on
		end

	end

	describe "Album songs" do 
		before do 
			@project = FactoryGirl.create(:album_project)
			@song = @project.songs.first
		end

		it "#finish_on should be between today and the project target date" do 
			assert @song.finish_on > Date.today
			assert @song.finish_on < @project.finish_on
		end

		it "second song in the project should be due after the first song" do
			assert @project.songs[1].finish_on > @song.finish_on
		end

		it "should determine the previous song" do 
			assert @project.songs[1].previous_song == @song
		end

		it "should return nil for the previous song if it is first" do 
			assert @song.previous_song == nil
		end

		it "should determine how many days to complete the song" do 
			assert @song.days_to_complete > 0
		end

		it "first song should have the same start date as the project" do 
			assert @song.start_on == @project.start_on
		end

		it "second song should start_on one day after first song ends" do 
			assert @project.songs[1].start_on == @song.finish_on.tomorrow
		end

		it "should determine if it is late" do 
			@project.finish_on = 1.day.ago
			@project.save
			@song.reload
			assert @song.late?
		end

		# it "should schedule songs with concurrency"
		# TODO: make an option where the songs are not due one after another,
		# but where all the preproduction happens together, then all the production
		# then all the post production.

	end

	describe "Song tasks" do 

		before do 
			setup_task_templates
			@project = FactoryGirl.create(:album_project)
			@song = @project.songs.first
		end

		it "should mark the song late if a task is late" do 
			task = @song.tasks.first
			task.due_on = 1.day.ago
			task.save
			@song.reload
			assert @song.late?
		end

	end

end
