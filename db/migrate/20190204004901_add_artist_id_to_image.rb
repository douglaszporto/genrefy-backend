class AddArtistIdToImage < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :artist_id, :integer
    add_index  :images, :artist_id
  end
end
