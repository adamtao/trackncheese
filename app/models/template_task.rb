# Dev. notes to myself. I think the way to figure this out is to have a series
# of Template Tasks--each categorized as pre, post, or production, and each with
# a score from 0..10. If the project's initial corresponding production level
# is less than the task's level, then generate it.
#
# I also thought it might be good to figure it out by some multiplier where the
# position of the song in the project affects how much is done, but that's making
# my head hurt.
#
class TemplateTask < ActiveRecord::Base

	def self.tasks_for(song_or_project)
		tasks = []
		project = (song_or_project.is_a?(Song)) ? song_or_project.project : song_or_project

		templates = where("task_type LIKE ?", "%#{ song_or_project.class.to_s }%")
		["preproduction", "production", "postproduction"].each do |stage|
			templates.where(production_stage: stage).where("score >= ?", eval("project.#{stage}")).order(:position).each do |tt|
			# templates.where(production_stage: stage).order(:position).each do |tt|
				tasks << Task.new(name: tt.name)
			end
		end

		tasks
	end
end
