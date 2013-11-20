require 'test_helper'

# Testing what you can do without even logging in.

class NonUserIntegrationTest < ActionDispatch::IntegrationTest

	describe "Creating a project" do
		it "should link from homepage to project form" do
			visit root_path
			page.click_on 'Produce An Album'
			current_path.must_equal album_new_project_path
		end

		it "form should have project fields" do
			visit album_new_project_path
			must_have_field :project_name
			must_have_field :project_finish_on
			must_have_field :project_pushiness
			must_have_field :project_preproduction
			must_have_field :project_production
			must_have_field :project_postproduction
			must_have_button "Start Project"
		end

		it "should be able to access project from menu" do
			p = my_cookie_project
			click_on "My Projects"
			must_have_link p.name, href: project_path(p)
			click_on p.name
			current_path.must_equal project_path(p)
		end

		it "should warn about being able to keep the project" do 
			p = my_cookie_project
			click_on "My Projects"
			must_have_content "you should login or create an account"
		end

		it "should NOT have access to projects not in your cookies" do 
			not_my_project = FactoryGirl.create(:album_project)
			visit project_path(not_my_project)
			current_path.must_equal root_path
		end

	end

	describe "Creating an album project" do

		before do 
			@attributes = FactoryGirl.attributes_for(:project, name: "Best Project Ever", finish_on: 6.months.from_now)
			visit album_new_project_path
		end

		it "should create a new album project" do
			fill_in :project_name, with: @attributes[:name]
			fill_in :project_finish_on, with: @attributes[:finish_on]
			click_on "Start Project"
			p = Project.last
			p.name.must_equal(@attributes[:name])
			p.songs.length.must_be('>', 1)
		end

		it "should redirect to the project view page" do
			click_on "Start Project"
			p = Project.last
			current_path.must_equal project_path(p)
		end

		it "should warn about saving the project to an account" do 
			click_on "Start Project"
			must_have_content "Important!"
			must_have_content "you should login or create an account"
		end

	end

	describe "Creating a new single project" do

		before do
			@attributes = FactoryGirl.attributes_for(:project, name: "Best Single Ever", finish_on: 3.months.from_now)
			visit single_new_project_path
		end

		it "should create a new single project" do
			fill_in :project_name, with: @attributes[:name]
			fill_in :project_finish_on, with: @attributes[:finish_on]
			click_on "Start Project"
			p = Project.last
			p.name.must_equal(@attributes[:name])
			p.songs.length.must_equal(1)
		end

		it "should redirect to the song page" do
			click_on "Start Project"
			p = Project.last
			song = p.songs.first
			current_path.must_equal project_song_path(p, song)
		end

		it "song title should be the same as the project name" do
			fill_in :project_name, with: @attributes[:name]
			click_on "Start Project"
			p = Project.last
			p.songs.first.title.must_equal(p.name)
		end

	end

	describe "Claiming ownership" do 

		# setup an anonymous project
		before do 
			@project = my_cookie_project
			visit "/identities/new" 
			fill_in :name, with: "Joe Schmoe"
			fill_in :email, with: "joe@schmoe.com"
			fill_in :password, with: "abc123"
			fill_in :password_confirmation, with: "abc123"
			click_on "Register"
		end

		it "should claim the project when logging in" do
			user = User.last
			@project.reload.user_id.must_equal user.id
		end

		it "should remove the project from the cookies once claimed" do 
			click_on 'Logout'
			wont_have_link "My Projects" # menu link to My Projects goes away
			visit projects_path # even though link is gone, visit My Projects page
			wont_have_link @project.name
			wont_have_content "Important!"
			must_have_content "There doesn't seem to be anything here."
		end

	end

end