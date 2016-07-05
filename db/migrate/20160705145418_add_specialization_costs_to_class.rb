class AddSpecializationCostsToClass < ActiveRecord::Migration
  def change
    add_column :character_classes, :attack_specialization_cost, :integer, default: 10
    add_column :character_classes, :speed_specialization_cost, :integer, default: 10
    add_column :character_classes, :defense_specialization_cost, :integer, default: 10
    add_column :character_classes, :damage_specialization_cost, :integer, default: 10
  end
end
