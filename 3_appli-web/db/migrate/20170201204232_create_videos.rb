class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :url
      t.references :chaine, foreign_key: true

      t.timestamps
    end
  end
end
