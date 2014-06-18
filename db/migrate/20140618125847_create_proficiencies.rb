class CreateProficiencies < ActiveRecord::Migration
  def change
    create_table :proficiencies do |t|
      t.string :name
      t.string :description
      t.string :requirements
      t.integer :bp_cost
      t.integer :item_id

      t.timestamps
    end

    create_table :characters_proficiencies do |t|
      t.integer :character_id
      t.integer :proficiency_id
    end

  end
end
