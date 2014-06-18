class ModifyItems < ActiveRecord::Migration
  def change
    remove_column :items, :size
    add_column :items, :shield_size, :string
    add_column :items, :armor_type, :string
    add_column :items, :name, :string
    add_column :items, :description, :string
    add_column :items, :attack_speed, :integer
    add_column :items, :jab_speed, :integer
    add_column :items, :reach, :float
    add_column :items, :buy_cost, :float
    add_column :items, :sell_value, :float
    add_column :items, :damage_type, :string
  end
end
