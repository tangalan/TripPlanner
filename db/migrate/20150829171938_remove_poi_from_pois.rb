class RemovePoiFromPois < ActiveRecord::Migration
  def change
    remove_column :pois, :poi, :string
  end
end
