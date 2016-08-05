class AddWeaponSetsAndStances < ActiveRecord::Migration
  def change
    create_table :item_sets do |t|
      t.integer :character_id
      t.integer :left_item_id
      t.integer :right_item_id
      t.integer :body_item_id
      t.string :stance

      t.timestamps
    end

    create_table :item_instances_item_sets do |t|
      t.integer :item_instance_id
      t.integer :item_set_id
    end
  end
end
