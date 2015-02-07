class RemoveAlbumIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :album_id, :string
  end
end
