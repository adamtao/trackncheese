class Task < ActiveRecord::Base
	belongs_to :project
	# or:
	belongs_to :song
	
	validates :name, presence: true
	validates :due_on, presence: true
	# validates :project_id, if: song.id.blank?
	# validates :song_id, if: project.id.blank?

	# Generates Tasks for either a Song or a Project based on production status settings
	# when the Project was created. 
	#
	def self.generate_for(song_or_project)
		song_or_project.tasks << TemplateTask.tasks_for(song_or_project)
		song_or_project.tasks.each_with_index{|t,i| t.determine_due_date(song_or_project, i)}
		song_or_project.save
	end

	def determine_due_date(song_or_project, position)
		dd = song_or_project.finish_on

		divisor = (song_or_project.tasks.length > 0) ? song_or_project.tasks.length : 1
		interval = (song_or_project.days_to_complete.to_i / divisor).to_i

		dd = song_or_project.start_on.advance(days: interval * position)
		dd = song_or_project.finish_on if dd > song_or_project.finish_on

		self.due_on = dd
	end

	def song_or_project
		self.song || self.project
	end

	def complete?
		self.completed_at.present?
	end

	# Determines if this task is late
	#
	def late?
		@late ||= (self.due_on < Date.today)	
	end

	# The color for this item on the calendar
	#
	def color_for_calendar
		@color_for_calendar ||= (self.song_id.present?) ? self.song.color_for_calendar : CALENDAR_COLORS.first
	end

end
