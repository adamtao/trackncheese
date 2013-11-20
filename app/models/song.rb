class Song < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

	belongs_to :project, inverse_of: :songs
	acts_as_list scope: :project

	validates :title, presence: true
	# validates :project_id, presence: true

  def slug_candidates
    [
      :title,
      [:title, :project_id],
      [:title, :project_id, :position]
    ]
  end

end
