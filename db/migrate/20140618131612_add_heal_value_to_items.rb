class AddHealValueToItems < ActiveRecord::Migration
  def change
    add_column :items, :heal_value, :integer
  end
end
