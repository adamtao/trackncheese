# Adding production defaults for paperclip on openshift hosting
#
Paperclip::Attachment.default_options[:use_timestamp] = false

Paperclip.interpolates(:timestamp) do |attachment, style|
  attachment.instance_read(:updated_at).to_i  
end

if Rails.env.production? && ENV['OPENSHIFT_DATA_DIR']
	Paperclip::Attachment.default_options.merge!({
    	url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    	path: "#{ENV['OPENSHIFT_DATA_DIR']}/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})
else
	Paperclip::Attachment.default_options.merge!({
    	url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    	path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})
end