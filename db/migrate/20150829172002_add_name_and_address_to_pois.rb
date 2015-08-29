class AddNameAndAddressToPois < ActiveRecord::Migration
  def change
    add_column :pois, :name, :string
    add_column :pois, :address, :string
  end
end
