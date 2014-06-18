class CreateTalents < ActiveRecord::Migration
  def change
    create_table :talents do |t|
      t.string :name
      t.string :description
      t.string :requirements
      t.integer :bp_cost
      t.integer :item_id

      t.timestamps
    end

    create_table :characters_talents do |t|
      t.integer :character_id
      t.integer :talent_id
    end

  end
end
