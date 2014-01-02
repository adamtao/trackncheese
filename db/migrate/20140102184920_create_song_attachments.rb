class CreateSongAttachments < ActiveRecord::Migration
  def change
    create_table :song_attachments do |t|
      t.integer :song_id
      t.string :attachment_file_name
      t.integer :attachment_file_size
      t.string :attachment_content_type
      t.datetime :attachment_updated_at

      t.timestamps
    end
    add_index :song_attachments, :song_id
  end
end
