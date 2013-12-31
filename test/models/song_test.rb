require 'test_helper'

class SongTest < ActiveSupport::TestCase

	describe "Single song" do 

		before do 
			setup_task_templates
			@project = FactoryGirl.create(:single_project)
			@song = @project.songs.first
		end

		it "#single? should be true" do 
			assert @song.single?
		end

		it "#finish_on should be the same as the project target date" do 
			assert_equal @song.finish_on, @project.finish_on
		end

		it "should have the same days_to_complete as the project" do 
			assert_equal @song.days_to_complete, @project.days_to_complete
		end

		it "should have the same start date as the project" do 
			assert_equal @song.start_on, @project.start_on
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
			assert_equal @project.songs[1].previous_song, @song
		end

		it "should return nil for the previous song if it is first" do 
			assert_equal @song.previous_song, nil
		end

		it "should determine how many days to complete the song" do 
			assert @song.days_to_complete > 0
		end

		it "first song should have the same start date as the project" do 
			assert_equal @song.start_on, @project.start_on
		end

		it "second song should start_on one day after first song ends" do 
			assert_equal @project.songs[1].start_on, @song.finish_on.tomorrow
		end

		it "should determine if it is late" do 
			@project.finish_on = 1.day.ago
			@project.created_at = 2.months.ago
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
			@song.generate_tasks
		end

		it "should mark the song late if a task is late" do 
			task = @song.tasks.first
			task.due_on = 2.day.ago
			task.save
			@song.reload
			assert @song.late?
		end

	end

	describe "Lyrics and Rhymes" do 

		before do 
			@song = FactoryGirl.create(:song)
			@lyrics = <<-LYRIC
    Other harvests there are than those that lie
    Glowing and ripe 'neath an autumn sky,
        Awaiting the sickle keen,
    Harvests more precious than golden grain,
    Waving o'er hillside, valley or plain,
        Than fruits 'mid their leafy screen.

LYRIC

		end

		it "should store lyrics" do 
			@song.lyrics = @lyrics
			@song.save
			assert @song.lyrics.present?
		end

		it "should parse each line for words to rhyme" do 
			@song.lyrics = @lyrics
			@song.save
			assert @song.words_for_rhyming.length == 6 # one for each line
			assert_includes @song.words_for_rhyming, "screen"
		end

		it "should have suggested rhymes for each line" do 
			@song.lyrics = @lyrics
			@song.save
			assert @song.rhyme_suggestions["screen"].length > 0
		end

	end

end
