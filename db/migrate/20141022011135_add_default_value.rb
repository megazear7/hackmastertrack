class AddDefaultValue < ActiveRecord::Migration
  def change
    change_column :characters, :spell_points, :integer, default: 0
    change_column :characters, :luck_points, :integer, default: 0
    change_column :characters, :building_points, :integer, default: 0
    change_column :characters, :exp, :integer, default: 0
    change_column :characters, :level, :integer, default: 1
  end
end
