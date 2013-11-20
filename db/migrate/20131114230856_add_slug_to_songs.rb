class AddSlugToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :cached_slug, :string
    add_index :songs, :cached_slug
  end
end
