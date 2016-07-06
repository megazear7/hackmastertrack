class CharactersTalentsAddItemId < ActiveRecord::Migration
  def change
    add_column :characters_talents, :item_id, :integer
  end
end
