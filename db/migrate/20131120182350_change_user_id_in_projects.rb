# Goofed up in the initial migration. User id should be an int, duh.

class ChangeUserIdInProjects < ActiveRecord::Migration
  def up
  	change_column :projects, :user_id, :integer
  end

  def down
  	change_column :projects, :user_id, :string
  end
end
