class ChangeSkillLevelDataTypeInItems < ActiveRecord::Migration
  def change
    change_column :items, :skill_level, :string
  end
end
