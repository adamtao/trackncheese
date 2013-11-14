class AddProductionIndicatorsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :preproduction, :integer
    add_column :projects, :production, :integer
    add_column :projects, :postproduction, :integer
    add_column :projects, :pushiness, :integer
  end
end
