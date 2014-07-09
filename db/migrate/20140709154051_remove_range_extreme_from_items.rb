class RemoveRangeExtremeFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :range_extreme, :integer
  end
end
