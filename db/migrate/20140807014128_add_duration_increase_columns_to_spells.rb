class AddDurationIncreaseColumnsToSpells < ActiveRecord::Migration
  def change
    add_column :spells, :duration_increase, :integer
    add_column :spells, :duration_increase_cost, :integer
  end
end
