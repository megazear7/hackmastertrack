class CreateClassSpellbooks < ActiveRecord::Migration
  def change
    create_table :class_spellbooks do |t|
      t.integer :character_class_id
      t.integer :spell_id
      t.integer :level

      t.timestamps
    end
  end
end
