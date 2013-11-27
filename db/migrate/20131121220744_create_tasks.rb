class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.date :due_on
      t.date :completed_on
      t.integer :song_id
      t.integer :project_id

      t.timestamps
    end
    add_index :tasks, :song_id
    add_index :tasks, :project_id
  end
end
