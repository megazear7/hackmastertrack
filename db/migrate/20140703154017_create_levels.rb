class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.integer :level_value
      t.integer :init_mod
      t.integer :attack_mod
      t.integer :speed_mod
      t.integer :spell_points

      t.integer :character_class_id

      t.timestamps
    end
  end
end
