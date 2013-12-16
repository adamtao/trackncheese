require 'test_helper'

class TaskTest < ActiveSupport::TestCase
	describe "Song tasks" do 

		before do 
			setup_task_templates
			@project = FactoryGirl.create(:album_project)
			@song = @project.songs.first
			@song.generate_tasks
		end

		it "should auto-generate tasks" do 
			song_template_tasks = TemplateTask.where("task_type LIKE '%song%'").count
			assert_equal @song.tasks.count, song_template_tasks
		end

		it "should determine due date for tasks" do 
			assert_present @song.tasks.first.due_on
		end

		it "should determine if a task is late" do 
			task = @song.tasks.first
			task.due_on = 1.day.ago
			task.save
			@song.reload
			assert task.late?
		end

	end

end
