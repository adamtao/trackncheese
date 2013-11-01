class AddFinishDateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :finish_on, :date
  end
end
