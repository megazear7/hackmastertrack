class AddColumnsToItems < ActiveRecord::Migration
  def change
    add_column :items, :high_avail, :integer
    add_column :items, :med_avail, :integer
    add_column :items, :low_eval, :integer
    add_column :items, :init_die_mod, :integer
    add_column :items, :movement_rate_reduction, :integer
    add_column :items, :crouching_cover_value, :integer
    add_column :items, :shield_damage, :integer
    add_column :items, :str_required, :integer
    add_column :items, :skill_level, :integer
    add_column :items, :dismount, :boolean
    add_column :items, :hvy_armor, :integer
    add_column :items, :set_for_charge, :boolean
    add_column :items, :pole_arm_defense, :string
    add_column :items, :pole_arm_type, :string
    add_column :items, :phalanx, :integer
  end
end
