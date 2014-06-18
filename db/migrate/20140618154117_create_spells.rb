class CreateSpells < ActiveRecord::Migration
  def change
    create_table :spells do |t|
      t.string :name
      t.string :description
      t.integer :spellpoints
      t.string :type

      t.timestamps
    end

    create_table :characters_spells do |t|
      t.integer :character_id
      t.integer :spell_id
    end

  end
end
