class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.float :strength
      t.float :intelligence
      t.float :wisdom
      t.float :dexterity
      t.float :constitution
      t.float :looks
      t.float :charisma
      t.float :honor
      t.float :fame
      t.integer :building_points
      t.integer :health
      t.string :name
      t.integer :level
      t.string :alignment
      t.string :sex
      t.integer :age
      t.integer :height
      t.integer :weight
      t.string :hair
      t.string :eyes
      t.string :handedness
      t.string :trade_coins
      t.integer :copper
      t.integer :silver
      t.integer :gold
      t.integer :spell_points
      t.integer :luck_points

      t.timestamps
    end
  end
end
