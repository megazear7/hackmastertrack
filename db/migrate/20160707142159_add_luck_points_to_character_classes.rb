class AddLuckPointsToCharacterClasses < ActiveRecord::Migration
  def change
    add_column :character_classes, :luck_points, :integer
  end
end
