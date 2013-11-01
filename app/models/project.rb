class Project < ActiveRecord::Base
	belongs_to :user
	has_many :songs, order: :position
end
