class AddSecondTakeColumnsAaaToSpells < ActiveRecord::Migration
  def change
    add_column :spells, :damage_type, :string
  end
end
