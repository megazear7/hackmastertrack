class AddSecondTakeColumnsToSpells < ActiveRecord::Migration
  def change
    add_column :spells, :verbal, :boolean
    add_column :spells, :somatic, :boolean
    add_column :spells, :material_component, :string
    add_column :spells, :casting_time, :integer
    add_column :spells, :duration, :integer
    add_column :spells, :volume_of_effect_type, :string
    add_column :spells, :volume_of_effect, :integer
    add_column :spells, :volume_increase, :integer
    add_column :spells, :volume_increase_cost, :integer
    add_column :spells, :range, :integer
    add_column :spells, :range_increase, :integer
    add_column :spells, :range_increase_cost, :integer
    add_column :spells, :target_damage, :string
    add_column :spells, :target_damage_increase, :string
    add_column :spells, :target_damage_increase_cost, :integer
    add_column :spells, :area_damage, :string
    add_column :spells, :area_damage_increase, :string
    add_column :spells, :area_damage_increase_cost, :integer
    add_column :spells, :special_increase1, :string
    add_column :spells, :special_increase1_cost, :integer
    add_column :spells, :special_increase2, :string
    add_column :spells, :special_increase2_cost, :integer
    add_column :spells, :saving_throw, :string
    add_column :spells, :saving_throw_result, :string
    add_column :spells, :bounce_damage, :boolean
  end
end
