class RemoveCharactersSpells < ActiveRecord::Migration
  def change
    drop_table :characters_spells
  end
end
