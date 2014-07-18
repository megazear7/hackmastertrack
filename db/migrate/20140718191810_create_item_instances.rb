class CreateItemInstances < ActiveRecord::Migration
  def change
    create_table :item_instances do |t|
      t.integer "item_id"
      t.integer "character_id"
      t.integer "durability"
      t.integer "attack_mod"
      t.integer "speed_mod"
      t.integer "init_mod"
      t.integer "defense_mod"
      t.integer "damage_mod"
      t.integer "damage_reduction"
      t.integer "magic_level"
      t.integer "init_die_mod"
      t.timestamps
    end
  end
end
