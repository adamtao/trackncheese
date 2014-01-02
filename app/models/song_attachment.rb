class SongAttachment < ActiveRecord::Base
	has_attached_file :attachment, :styles => { :medium => "300x300>", :thumb => ["48x48#", :png] }
	before_post_process :skip_for_non_images
	belongs_to :song

	def skip_for_non_images
		! attachment_content_type.to_s.match(/image/i)
	end

end
