class AddVariousFieldstoSkills < ActiveRecord::Migration
  def change
    add_column :skills, :third_attr, :string
    add_column :skills, :universal, :boolean
    add_column :skills, :prerequisite, :string
    add_column :skills, :materials, :string
  end
end
