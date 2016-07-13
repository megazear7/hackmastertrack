class AddHasAndBelongsToManyBetweenClassesAndProficiencies < ActiveRecord::Migration
  def change
    create_table "character_classes_proficiencies", force: true do |t|
      t.integer "character_class_id"
      t.integer "proficiency_id"
    end
  end
end
