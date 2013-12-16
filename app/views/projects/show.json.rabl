collection @project.calendar_items(@params)

attributes :id
node(:start) { |s| s.is_a?(Song) ? s.start_on : s.due_on }
node(:end)   { |s| s.is_a?(Song) ? s.finish_on : nil }
node(:title) { |s| s.is_a?(Song) ? s.title : s.name.truncate(20) }
node(:url)   { |s| (s.is_a?(Song) || s.song_id.present?) ? project_song_path(@project, s) : nil}
node(:color) { |s| s.color_for_calendar }