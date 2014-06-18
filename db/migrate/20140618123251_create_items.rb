class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :type
      t.integer :attack_mod
      t.integer :speed_mod
      t.integer :init_mod
      t.integer :defense_mod
      t.integer :damage_mod
      t.integer :damage_reduction
      t.integer :magic_level
      t.integer :weight
      t.integer :cover_value
      t.integer :size
      t.string :location
      t.string :damage

      t.timestamps
    end

    create_table :characters_items do |t|
      t.integer :character_id 
      t.integer :item_id
    end

  end
end
