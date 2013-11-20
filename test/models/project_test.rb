require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

	describe "Single project" do 

		before do
			@project = FactoryGirl.create(:single_project)
		end

		it "should create one song named the same as the project" do 
			@project.songs.length.must_equal 1
			@project.songs.first.title.must_equal @project.name
		end
	end

end
