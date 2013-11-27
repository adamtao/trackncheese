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

	describe "Project page", :js => true do 

		before do
			@project = my_cookie_project
		end

		it "should show a calendar"
		it "might show a google ad"

		it "should have a status bar" do 
			must_have_css("#meter-#{@project.id}")
		end

		it "should have actual status in the song columns" do 
			song = @project.songs.first
			click_on song.title
			task = song.tasks.first
			visit toggle_project_song_task_path(@project, song, task)
			visit project_path(@project)
			song.reload
			must_have_content "#{song.percent_complete.to_i}%"
		end

		it "should show the goal finish date" do 
			must_have_content "Goal: finish by "
		end
		
		it "should have a button to delete the project" do 
			must_have_link "Delete project"
		end

		it "should delete the project and remove it from the cookies" do 
			count = Project.count 
			this_project_path = project_path(@project)
			click_on "Delete project"
			Project.count.must_equal(count - 1)
			current_path.must_equal projects_path 
			wont_have_link @project.name, href: this_project_path
		end

		it "should have project-level tasks" do 
			project_task = FactoryGirl.build(:album_art)
			find("ul#task-list").must_have_link project_task.name
		end

		it "should mark complete tasks" do 
			task = @project.tasks.first
			check task.id # which does the same thing as:
			visit toggle_project_task_path(@project, task) # js should take care of this
			task.reload
			assert task.complete?
		end

		it "should show completed tasks" do 
			task = @project.tasks.first
			visit toggle_project_task_path(@project, task)
			current_path.must_equal project_path(@project)
			must_have_css("ul#completed-tasks")
		end

		it "should add new tasks"
		it "should delete tasks"
		it "should edit tasks"

		it "should list songs" do 
			song = @project.songs.first
			must_have_link song.title, href: project_song_path(@project, song)
		end
		
		it "should quick-edit song names and project name" do
			skip "Add quick edit tests and functions"
			click_on "Quick edit" # This will be the alt tag of an image
		end

		it "should have a link to add a new song" do 
			must_have_link "Add a song", href: new_project_song_path(@project)
		end

		it "should add the new song to the project" do 
			count = @project.song_count
			click_on "Add a song" 
			fill_in :song_title, with: "Palabra a tu madre"
			click_on "Add song to project"
			@project.reload
			@project.song_count.must_equal (count + 1)
			current_path.must_equal project_path(@project)
		end
	end

end