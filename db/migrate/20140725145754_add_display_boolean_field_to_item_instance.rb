class AddDisplayBooleanFieldToItemInstance < ActiveRecord::Migration
  def change
    add_column :item_instances, :display, :boolean
  end
end
