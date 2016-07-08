class AddTalentsAndSkillsAndProficienciesToRace < ActiveRecord::Migration
  def change
    create_table :races_talents do |t|
      t.integer :race_id
      t.integer :talent_id
    end

    create_table :proficiencies_races do |t|
      t.integer :proficiency_id
      t.integer :race_id
    end
  end
end
