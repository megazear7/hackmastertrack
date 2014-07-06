class AddCharacterClassAndRaceIdsToCharacterTable < ActiveRecord::Migration
  def change
    add_column :characters, :character_class_id, :integer
    add_column :characters, :race_id, :integer
  end
end
