class CreateTemplateTasks < ActiveRecord::Migration
  def change
    create_table :template_tasks do |t|
      t.string :name
      t.integer :position
      t.integer :score
      t.string :task_type
      t.string :production_stage

      t.timestamps
    end
    add_index :template_tasks, :score
    add_index :template_tasks, :task_type
    add_index :template_tasks, :production_stage
  end
end
