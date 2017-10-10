class CreatePortraits < ActiveRecord::Migration[5.0]
  def change
    create_table :portraits do |t|
      t.string :filename
      t.references :image, foreign_key: true

      t.timestamps
    end
  end
end
