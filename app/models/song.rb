class Song < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

	belongs_to :project, inverse_of: :songs
	acts_as_list scope: :project

  has_many :tasks, -> { order :due_on }, dependent: :destroy
  has_many :attachments, :class_name => "SongAttachment" #, :foreign_key => "song_id"

	validates :title, presence: true
	# validates :project_id, presence: true

  # Moving this to the controller so the song count is correct
  # when generating/scheduling tasks.
  # after_create :generate_tasks

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

  # Determines if this song is late
  #
  def late?
    @late ||= (finish_on < Date.today) || self.late_tasks.length > 0
  end

  # Collects late tasks
  #
  def late_tasks
    @late_tasks ||= self.tasks.where(["due_on < ?", Date.today])
  end

  # Items for javascript calendar
  #
  def calendar_items
    @calendar_items ||= incomplete_tasks + [Task.new(name: "Finish song", due_on: self.finish_on)]
  end

  # The color for this item on the calendar
  #
  def color_for_calendar
    @color_for_calendar ||= CALENDAR_COLORS[self.position]
  end

  # List of words which might be useful for rhyming
  #
  def words_for_rhyming
    @words_for_rhyming ||= self.parse_lyrics_for_line_endings
  end

  # Parse the lyrics to come up with words for rhyming
  #
  def parse_lyrics_for_line_endings
    return [] if self.lyrics.blank?
    w = []
    self.lyrics.split(/\r\n|\r|\n/).each do |line|
      if word = line.split(/\s/).last
        word.gsub!(/[^a-zA-Z]/, "")
        w << word if word.length > 1
      end
    end
    w.uniq
  end

  # Suggest rhymes for each line of text in the song's lyrics
  #
  def rhyme_suggestions
    r = Rhymes.new
    rhymes = {}
    self.words_for_rhyming.each do |w|
      begin
        rhymes[w] = r.rhyme(w)
      rescue Rhymes::UnknownWord
        rhymes[w] = ["(no rhymes--unknown word)"]
      end
    end
    rhymes
  end
end
