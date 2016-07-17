class AddTalentsAndSkillsToCharacter < ActiveRecord::Migration
  def change
    create_table "character_classes_skills", force: true do |t|
      t.integer "character_class_id"
      t.integer "skill_id"
      t.integer "count",    default: 1
    end

    create_table "character_classes_talents", force: true do |t|
      t.integer "character_class_id"
      t.integer "talent_id"
    end
  end
end
