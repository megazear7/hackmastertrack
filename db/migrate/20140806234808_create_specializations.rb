class CreateSpecializations < ActiveRecord::Migration
  def change
    create_table :specializations do |t|
      t.integer :item_id
      t.integer :character_id
      t.integer :value
      t.string  :stat_name
      t.timestamps
    end
  end
end
