class AddColumnsVisionInitStatsToRaces < ActiveRecord::Migration
  def change
    add_column :races, :lowlightvision, :boolean
    add_column :races, :initdiebonus, :boolean
    add_column :races, :maleheight, :integer
    add_column :races, :femaleheight, :integer
    add_column :races, :maleweight, :integer
    add_column :races, :femaleweight, :integer
    add_column :races, :lifespan, :integer
  end
end
