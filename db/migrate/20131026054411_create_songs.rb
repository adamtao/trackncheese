class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.integer :project_id
      t.integer :position

      t.timestamps
    end
  end
end
