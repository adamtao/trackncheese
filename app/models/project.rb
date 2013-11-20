class Project < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

	belongs_to :user
	attr_accessor :song_count
	has_many :songs, -> { order :position }

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

end
