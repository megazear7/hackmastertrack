class AddCcrtdColumnsToItems < ActiveRecord::Migration
  def change
    add_column :items, :capacity_pounds, :float
    add_column :items, :capacity_gallons, :float
    add_column :items, :number_of_days, :integer
    add_column :items, :requires_preparation, :boolean
    add_column :items, :distance, :integer
  end
end
