class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.string :description
      t.integer :bp_cost
      t.string :main_attr
      t.string :other_attr

      t.timestamps
    end

    create_table :characters_skills do |t|
      t.integer :character_id
      t.integer :skill_id
    end

  end
end
