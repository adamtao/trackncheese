# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name "My Task"
    due_on 2.weeks.from_now
    song
    project
  end
end
