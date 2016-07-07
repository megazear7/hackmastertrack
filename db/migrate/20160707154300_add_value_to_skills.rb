class AddValueToSkills < ActiveRecord::Migration
  def change
    add_column :characters_skills, :value, :integer
  end
end
