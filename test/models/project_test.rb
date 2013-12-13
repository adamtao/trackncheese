require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

	describe "Single project" do 

		before do
			@project = FactoryGirl.create(:single_project)
		end

		it "should create one song named the same as the project" do 
			@project.songs.length.must_equal 1
			assert_equal @project.songs.first.title, @project.name
		end

		it '#single? should be true' do 
			assert @project.single?
		end
		
	end

	describe "Project tasks" do
		before do 
			setup_task_templates
			@project = FactoryGirl.create(:album_project)
		end

		it "should auto-generate tasks" do 
			assert @project.tasks.count > 0
		end

		it "should assign due date" do 
			assert_present @project.tasks.first.due_on
		end
	end

end
