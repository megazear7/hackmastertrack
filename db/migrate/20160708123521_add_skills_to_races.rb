class AddSkillsToRaces < ActiveRecord::Migration
  def change
    create_table :races_skills do |t|
      t.integer :race_id
      t.integer :skill_id
      t.integer :count, default: 1
    end
  end
end
