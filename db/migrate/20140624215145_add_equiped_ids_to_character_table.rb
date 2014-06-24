class AddEquipedIdsToCharacterTable < ActiveRecord::Migration
  def change
    add_column :characters, :left_hand_item_id, :integer
    add_column :characters, :right_hand_item_id, :integer
    add_column :characters, :body_item_id, :integer
  end
end
