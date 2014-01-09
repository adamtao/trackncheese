# Attachments should be a mix of audio, pdf, images, etc.
#
# TODO: fix paperclip to work with all file types and only create thumbs for images
#  (commented out code didn't work)
#
class SongAttachment < ActiveRecord::Base
	belongs_to :song
	has_attached_file :attachment #, :styles => { :medium => "300x300>", :thumb => ["48x48#", :png] }
	# before_post_process :skip_for_non_images

	# def skip_for_non_images
	# 	! attachment_content_type.to_s.match(/image/i)
	# end

end
