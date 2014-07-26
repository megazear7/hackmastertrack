class ChangeTypeNameToSpellTypeInSpells < ActiveRecord::Migration
  def change
    rename_column :spells, :type, :spell_type
  end
end
