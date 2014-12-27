class Spellbooks < ActiveRecord::Migration
  def change
    rename_table :class_spellbooks, :class_spells 
  end
end
