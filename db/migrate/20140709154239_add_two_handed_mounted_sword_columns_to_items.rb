class AddTwoHandedMountedSwordColumnsToItems < ActiveRecord::Migration
  def change
    add_column :items, :two_handed, :boolean
    add_column :items, :mounted, :boolean
    add_column :items, :sword, :boolean
  end
end
