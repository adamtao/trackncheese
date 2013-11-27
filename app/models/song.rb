class Song < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

	belongs_to :project, inverse_of: :songs
	acts_as_list scope: :project

  has_many :tasks, -> { order :due_on }, dependent: :destroy

	validates :title, presence: true
	# validates :project_id, presence: true

  after_create :generate_tasks

  def slug_candidates
    [
      :title,
      [:title, :project_id],
      [:title, :project_id, :position]
    ]
  end

  def single?
    self.project.single?
  end

  # Here's some magic, setup the initial tasks for the song.
  # Magic is determining when the task is due based on the project finish goal
  # AND the position of this song related to the rest of the songs in the
  # project. The other magic is determining which tasks need to be generated
  # based on the project's configuration regarding how much of the
  # production (pre, post) is done.
  #
  def generate_tasks
    Task.generate_for(self)
  end

  def percent_complete
    return self.project.percent_complete if self.single?
    if completed_tasks.count > 0
      ( completed_tasks.count.to_f / tasks.count.to_f ) * 100.0
    else
      0
    end
  end

  def completed_tasks
    return self.project.project_wide_completed_tasks if self.single?
    @completed_tasks ||= tasks.where("completed_at IS NOT NULL AND completed_at <= ?", Date.tomorrow).order("completed_at DESC")
  end

  def incomplete_tasks
    return self.project.project_wide_incomplete_tasks if self.single?
    @incomplete_tasks ||= tasks.where("completed_at IS NULL OR completed_at > ?", Date.tomorrow).order("due_on ASC")
  end

  # Dynamically calculate the goal finish date of the song based on the project's
  # finish goal and the position of the song related to the rest of the
  # project's songs.
  #
  def finish_on
    return self.project.finish_on if self.single? 
    @finish_on ||= self.project.created_at.advance(days: project.song_interval_in_days * self.position).to_date
  end

  # What day to start working on this Song. (The day after previous song in the project ends)
  #
  def start_on
    return self.project.start_on if self.single?
    @start_on ||= (self.previous_song.is_a?(Song)) ? self.previous_song.finish_on.tomorrow : self.project.start_on
  end

  # How many days from start to finish to complete this Song
  #
  def days_to_complete
    (finish_on.to_date - start_on).to_i
  end

  # The song previous to this one in the project (if any)
  #
  def previous_song
    self.higher_item
  end

end
