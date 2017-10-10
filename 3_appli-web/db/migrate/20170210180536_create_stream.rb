class CreateStream < ActiveRecord::Migration[5.0]
  def change
    create_table :streams do |t|
      t.string :type
    end
  end
end
