class AddStreamToChaine < ActiveRecord::Migration[5.0]
  def change
    add_reference :chaines, :stream, foreign_key: true
  end
end
