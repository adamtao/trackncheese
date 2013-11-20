class Identity < OmniAuth::Identity::Models::ActiveRecord
	validates :name, presence: true
  validates :email, presence: true, format: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
end
