class AddFinishedBooleanToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :finished, :boolean
  end
end
