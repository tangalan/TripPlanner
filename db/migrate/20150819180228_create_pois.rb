class CreatePois < ActiveRecord::Migration
  def change
    create_table :pois do |t|
      t.string :poi
      t.references :trip, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
