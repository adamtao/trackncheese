module SongsHelper

	def rhyme_format(word)
		word.downcase.gsub(/\_/, ". ")
	end
end
