class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :place

      t.timestamps null: false
    end
  end
end
