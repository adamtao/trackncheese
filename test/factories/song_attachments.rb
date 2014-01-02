# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :song_attachment do
    song
    attachment_file_name "MyString.mp3"
    attachment_file_size 99999
    attachment_content_type "audio/mp3"
    attachment_updated_at 1.day.ago
  end
end
