class CreateAbilityScores < ActiveRecord::Migration
  def change
    create_table :ability_scores do |t|
      t.string  :ability
      t.text    :value_range
      t.integer :feat_of_strength
      t.integer :lift
      t.integer :carry
      t.integer :drag
      t.integer :damage_mod
      t.integer :init_mod
      t.integer :speed_mod
      t.integer :attack_mod
      t.integer :defense_mod
      t.integer :turning_mod
      t.integer :feat_of_agility
      t.integer :mental_saving_throw_bonus
      t.integer :dodge_saving_throw_bonus
      t.integer :physical_saving_throw_bonus
      t.integer :morale_mod

      t.timestamps
    end
  end
end
