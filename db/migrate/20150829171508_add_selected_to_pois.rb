class AddSelectedToPois < ActiveRecord::Migration
  def change
    add_column :pois, :selected, :boolean, :default => false
  end
end
