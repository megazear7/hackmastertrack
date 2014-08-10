class AddLevelDescriptionFieldstoSkills < ActiveRecord::Migration
  def change
    add_column :skills, :unskilled, :string
    add_column :skills, :novice, :string
    add_column :skills, :average, :string
    add_column :skills, :advanced, :string
    add_column :skills, :expert, :string
    add_column :skills, :master, :string
  end
end
