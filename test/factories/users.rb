# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Jonny"
    email "johnny@johnny.com"
    provider "identity"
    uid "234598723405982734"
  end
end
