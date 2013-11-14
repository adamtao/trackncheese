class HomeController < ApplicationController
  def index
		# two background images alternated every week (0.jpg, 1.jpg)
		@bg = "bg/#{Time.now.strftime("%U").to_i % 2}.jpg"
  end
end
