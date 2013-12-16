collection @song.calendar_items

attributes :id
node(:start) { |s| s.due_on }
node(:title) { |s| s.name.truncate(20) }
node(:color) { |s| @song.color_for_calendar }
