# Adding production defaults for paperclip on openshift hosting
#
if Rails.env.production?
	Paperclip::Attachment.default_options.merge!({
    	url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    	path: "#{OPENSHIFT_DATA_DIR}/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})
else
	Paperclip::Attachment.default_options.merge!({
    	url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    	path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})
end