class CharacterClassHasHitDice < ActiveRecord::Migration
  def change
    add_column :character_classes, :hit_dice_size, :integer, :default => 0
  end
end
