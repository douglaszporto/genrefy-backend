class CreateArtistsUsersJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :artists, :users do |t|
      t.index :artist_id
      t.index :user_id
    end
  end
end
