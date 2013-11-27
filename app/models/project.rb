class Project < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

	belongs_to :user
	attr_accessor :song_count
	has_many :songs, -> { order :position }, dependent: :destroy
	has_many :tasks, -> { order :due_on }, dependent: :destroy

	after_create :generate_tasks

	# Instatiate a new album project with some default values.
	#
	def self.new_album(song_count=1)
		pname = (song_count == 1) ? 'My Single' : 'My Album'
		pname = "My Music Project" if song_count < 1
		new( 
			name: pname,
			preproduction: 0,
			production: 0,
			postproduction: 0,
			pushiness: 2,
			song_count: song_count,
			finish_on: song_count.months.from_now.to_date
		)
	end

	# Instatiate a new single song project with some default values.
	#
	def self.new_single
		new_album(1)
	end

  # Setup the initial tasks for the Project. (project-wide)
  #
  def generate_tasks
    Task.generate_for(self)
  end

  def percent_complete
    if project_wide_completed_tasks.length > 0
      ( project_wide_completed_tasks.length.to_f / project_wide_tasks.length.to_f ) * 100.0
    else
      0
    end
  end

  def completed_tasks
    @completed_tasks ||= tasks.where("completed_at IS NOT NULL AND completed_at <= ?", Date.tomorrow).order("completed_at DESC")
  end

  def incomplete_tasks
    @incomplete_tasks ||= tasks.where("completed_at IS NULL OR completed_at > ?", Date.tomorrow).order("due_on ASC")
  end

  def project_wide_completed_tasks
  	@project_wide_completed_tasks ||= project_wide_tasks.where("completed_at IS NOT NULL AND completed_at <= ?", Date.tomorrow).order("completed_at DESC")
  end

  def project_wide_incomplete_tasks
  	@project_wide_incomplete_tasks ||= project_wide_tasks.where("completed_at IS NULL OR completed_at > ?", Date.tomorrow).order("due_on ASC")
  end

  def project_wide_tasks
  	@project_wide_tasks ||= Task.where("project_id = ? OR song_id IN (?)", self.id, self.songs.pluck(:id))
  end

  def slug_candidates
    [
      :name,
      [:name, :created_at],
      [:name, :created_at, :user_id]
    ]
  end

	def song_count=(num)
		if num.to_i == 1
			self.songs << Song.new(title: self.name)
		else
			1.upto(num.to_i) {|i| self.songs << Song.new(title: "Song ##{i}") }
		end
	end

	def song_count
		self.songs.length
	end

	def single?
		song_count == 1
	end

	# The number of days for each song to be finished within the project
	#
	def song_interval_in_days
    @song_interval_in_days ||= case song_count
    	when 0 
    		days_to_complete
    	else
    		days_to_complete / song_count
    end
	end

	def start_on
		created_at.to_date
	end

	def days_to_complete
		(finish_on.to_date - start_on).to_i
	end

end
