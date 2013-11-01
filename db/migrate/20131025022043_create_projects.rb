class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :user_id
      t.string :cached_slug

      t.timestamps
    end
    add_index :projects, :cached_slug
  end
end
