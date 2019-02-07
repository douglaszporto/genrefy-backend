class CreateArtists < ActiveRecord::Migration[5.1]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :spotify_id
      t.string :href
      t.string :popularity
      t.string :uri
      t.string :external_urls
      t.integer :followers

      t.timestamps
    end
  end
end
