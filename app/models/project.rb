class Project < ActiveRecord::Base
	extend FriendlyId
  friendly_id :name, use: :slugged

	belongs_to :user
	attr_accessor :song_count
	has_many :songs, -> { order :position }

	# Instatiate a new album project with some default values.
	#
	def self.new_album(song_count=1)
		pname = (song_count == 1) ? 'My Single' : 'My Album'
		p = new( 
			name: pname,
			preproduction: 0,
			production: 0,
			postproduction: 0,
			pushiness: 2,
			finish_on: song_count.months.from_now.to_date
		)
		song_count.times { p.songs.build }
		p
	end

	# Instatiate a new single song project with some default values.
	#
	def self.new_single
		new_album(1)
	end

	def song_count=(num)
		1.upto(num.to_i) {|i| self.songs << Song.new(title: "Song ##{i}") }
	end

	def song_count
		self.songs.length
	end

end
