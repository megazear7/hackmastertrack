class AddNameToItemInstance < ActiveRecord::Migration
  def change
    add_column :item_instances, :name, :string
  end
end
