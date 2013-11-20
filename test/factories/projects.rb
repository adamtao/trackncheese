# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name "My Project"
    user
		finish_on 1.year.from_now
		preproduction 0
		production 0
		postproduction 0
		pushiness 3

		factory :single_project do 
			song_count 1
		end

		factory :album_project do 
			song_count 12
		end

  end

end
