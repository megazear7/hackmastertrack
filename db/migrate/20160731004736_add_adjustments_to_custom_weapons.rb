class AddAdjustmentsToCustomWeapons < ActiveRecord::Migration
  def change
    add_column :item_instances, :shield_damage_reduction, :integer, default: 0

    add_column :item_instances, :worn_init_die_mod, :integer, default: 0
    add_column :item_instances, :worn_attack_mod, :integer, default: 0
    add_column :item_instances, :worn_speed_mod, :integer, default: 0
    add_column :item_instances, :worn_init_mod, :integer, default: 0
    add_column :item_instances, :worn_defense_mod, :integer, default: 0
    add_column :item_instances, :worn_damage_mod, :integer, default: 0
    add_column :item_instances, :worn_damage_reduction, :integer, default: 0
    add_column :item_instances, :worn_shield_damage_reduction, :integer, default: 0
  end
end
