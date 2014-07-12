class AddColumnsToRaces < ActiveRecord::Migration
  def change
    add_column :races, :size, :string
    add_column :races, :knockbacksize, :string
  end
end
