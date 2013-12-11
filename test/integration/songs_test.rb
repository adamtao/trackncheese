require 'test_helper'

# Testing what you can do with songs

class SongsIntegrationTest < ActionDispatch::IntegrationTest

	describe "Single song project" do 

		before do
			@project = my_cookie_single
			@song = @project.songs.first
			visit project_path(@project)
		end

		it "should land on the song page when visiting the project" do 
			current_path.must_equal project_song_path(@project, @song)
		end

		it "should not link to the parent project" do 
			wont_have_link "Back", href: project_path(@project)
		end

		it "should have a link to add a song to the parent project" do 
			must_have_link "Add a song", href: new_project_song_path(@project)
		end

		it "should change to a multisong project after adding a song" do
			click_on "Add a song"
			fill_in :song_title, with: "Super silly song"
			click_on "Add song to project"
			@project.reload
			@project.song_count.must_equal 2
			current_path.must_equal project_path(@project)
		end

		it "should have a link to delete the project" do 
			must_have_link "delete project"
		end

		it "should delete the project and remove it from the cookies" do 
			count = Project.count 
			this_project_path = project_path(@project)
			click_on "delete project"
			Project.count.must_equal(count - 1)
			current_path.must_equal projects_path 
			wont_have_link @project.name, href: this_project_path
		end

		it "should show the parent project tasks" do 
			project_task = @project.tasks.first
			must_have_link project_task.name
		end

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

	describe "Multi-song project" do 
		before do 
			@project = my_cookie_project
			@song = @project.songs.first
			visit project_song_path(@project, @song)
		end

		it "should link to the project page" do 
			must_have_link "Back", href: project_path(@project)
		end

		it "should not link to add more songs" do
			wont_have_link "Add a song"
		end

		it "should have a button to delete the song" do 
			must_have_link "delete song"
		end

		it "should delete the song from the project" do 
			count = @project.song_count 
			this_song_path = project_song_path(@project, @song)
			click_on "delete song"
			@project.reload
			@project.song_count.must_equal(count - 1)
			current_path.must_equal project_path(@project)
			wont_have_link @song.title, href: this_song_path
		end

		it "should show when the song should be done" do 
			must_have_content I18n.l(@song.finish_on, format: :long)
		end

	end

	describe "Song page" do 
		before do 
			@project = my_cookie_project
			@song = @project.songs.first
			visit project_song_path(@project, @song)
		end

		it "should show tasks" do 
			song_task = FactoryGirl.build(:master)
			must_have_link song_task.name
		end

		it "should mark complete tasks" do 
			task = @song.tasks.first
			check task.id # which does the same thing as:
			visit toggle_project_song_task_path(@project, @song, task) # js should take care of this
			task.reload
			assert task.complete?
		end

		it "should show completed tasks" do 
			task = @song.tasks.first
			visit toggle_project_song_task_path(@project, @song, task)
			current_path.must_equal project_song_path(@project, @song)
			must_have_css("ul#completed-tasks")
		end

		it "should show a progress indicator" do 
			must_have_css("#meter-#{ @song.project_id }")
		end

		it "should indicate late tasks" do 
			task = @song.tasks.first
			task.due_on = 1.day.ago
			task.save
			visit project_song_path(@project, @song)
			must_have_css("a.late")
		end
		
		it "should add new tasks" do 
			task_count = @song.tasks.length
			click_on "new task"
			fill_in :task_name, with: "Watch TV"
			fill_in :task_due_on, with: 2.weeks.from_now
			click_on "Save task"
			@song.reload
			@song.tasks.count.must_equal( task_count + 1 )
			current_path.must_equal project_song_path(@project, @song)
		end

		it "should delete tasks"
		
		it "should edit tasks" do 
			task = @song.tasks.first
			new_due_date = 6.months.from_now.to_date
			new_task_name = "#{task.name}999"
			click_on task.name
			fill_in :task_name, with: new_task_name
			fill_in :task_due_on, with: new_due_date
			click_on "Save task"
			task.reload
			task.name.must_equal new_task_name
			task.due_on.must_equal new_due_date
			current_path.must_equal project_song_path(@project, @song)
		end

		it "should have the arranger"
		it "should have a calendar"

		it "might show a google ad" do 
			must_have_xpath("//div[@style='width:300px;height:250px;background:#c8c8c8;']")
		end

	end

end