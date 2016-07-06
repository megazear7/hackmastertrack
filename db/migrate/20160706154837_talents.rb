class Talents < ActiveRecord::Migration
  def change
    add_column :talents, :item_specific, :boolean, default: false
  end
end
