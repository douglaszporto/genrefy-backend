class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :url
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
