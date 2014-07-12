class AddSpellsSpeedInitHitDiceColumnsToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :stvsspells, :integer
    add_column :levels, :addedspells, :string
    add_column :levels, :rangedspeedmod, :integer
    add_column :levels, :initiativediemod, :integer
    add_column :levels, :hitdice, :string
  end
end
