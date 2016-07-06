class TalentsRemoveItemId < ActiveRecord::Migration
  def change
    remove_column :talents, :item_id, :integer
  end
end
