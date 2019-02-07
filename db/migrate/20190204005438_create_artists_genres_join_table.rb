class CreateArtistsGenresJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :artists, :genres do |t|
      t.index :artist_id
      t.index :genre_id
    end
  end
end
