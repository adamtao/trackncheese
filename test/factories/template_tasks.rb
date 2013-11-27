# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :template_task do
    name "Write Song"
    task_type "Song" # or "Project"
    production_stage "production"

    trait :preproduction do 
    	production_stage "preproduction"
    end

    trait :production do
    	production_stage "production"
    end

    trait :postproduction do
    	production_stage "postproduction"
    end

    trait :song do
    	task_type "Song"
    end

    trait :project do 
    	task_type "Project"
    end

    factory :song_concept, traits: [:preproduction, :song] do 
    	name "Determine song concept"
    	position 1
    	score 0
    end

    factory :write_lyrics, traits: [:preproduction, :song] do
    	name "Write lyrics"
    	position 2
    	score 2
    end

    factory :write_melody, traits: [:preproduction, :song] do 
    	name "Write melody"
    	position 3
    	score 2
    end

    factory :write_chords, traits: [:preproduction, :song] do
    	name "Write chords"
    	position 4
    	score 3
   end

    factory :song_license, traits: [:preproduction, :song] do 
    	name "Obtain use license (if cover song)"
    	position 1
    	score 0
    end

    factory :arrange_song, traits: [:preproduction, :song] do 
    	name "Arrange song"
    	position 5
    	score 5
    end

    factory :practice_parts, traits: [:preproduction, :song] do 
    	name "Practice all parts"
    	position 6
    	score 7
    end

    factory :get_studio_musicians, traits: [:preproduction, :song] do 
    	name "Get studio musicians and provide parts for practice"
    	position 6
    	score 6
    end

    factory :record_parts, traits: [:production, :song] do 
    	name "Record all parts"
    	position 7
    	score 4
    end

    factory :edit_parts, traits: [:postproduction, :song] do 
    	name "Edit/comp recorded performances"
    	position 8
    	score 2
    end

    factory :mix, traits: [:postproduction, :song] do 
    	name "Mix song"
    	position 9
    	score 4
    end

    factory :master, traits: [:postproduction, :song] do 
    	name "Master song"
    	position 10
    	score 8
    end

    factory :album_art, traits: [:production, :project] do 
    	name "Produce album artwork"
    	position 3
    	score 7
    end

    factory :pick_studio, traits: [:preproduction, :project] do 
    	name "Find and decide on a studio and engineer for recording"
    	position 1
    	score 3
    end

    factory :mix_engineer, traits: [:postproduction, :project] do 
    	name "Choose a mix engineer"
    	position 3
    	score 7
    end

    factory :mastering_engineer, traits: [:postproduction, :project] do 
    	name "Choose a mastering engineer"
    	position 7
    	score 8
    end

    factory :upload_final_product, traits: [:postproduction, :project] do 
    	name "Upload final product to be distributed"
    	position 9
    	score 9
    end

    factory :execute_marketing_plan, traits: [:postproduction, :project] do 
    	name "Execute marketing plan"
    	position 10
    	score 9
    end

  end
end
