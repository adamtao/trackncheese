class Song < ActiveRecord::Base
	belongs_to :project
	acts_as_list scope: :project

	# These make the new project creation fail.
	# validates :title, presence: true
	# validates :project_id, presence: true
end
